class Question < ActiveRecord::Base
  after_initialize :set_defaults
  
  attr_accessible :kind, :question, :state, :countdown_to
  belongs_to :section
  has_many :answer_variants, :order => "position asc", :dependent => :destroy
  validates :question, :kind, :state, :presence => true
  validates :question, :uniqueness => {:scope => [:section_id]}
  validates :kind, :inclusion => {:in => %w(radio check stars)}
  validates :state, :inclusion => {:in => %w(new active answered finished)}

  def start_countdown(seconds)
    case self.state
    when "new", "active"
      self.update_attributes :state => "active", :countdown_to => Time.now + seconds.to_i
    end
  end

  def stop_countdown
    if self.stop_countdown?
      self.update_attributes :state => "answered", :countdown_to => nil
    end
  end

  def self.stop_countdown?
    self.countdown_to and Time.now >= self.countdown_to
  end

  def countdown_expired
    if self.countdown_to
      if self.stop_countdown?
        self.stop_countdown
        nil
      else
        (self.countdown_to - Time.now).round
      end
    else
      nil
    end
  end
  
  def switch_state
    case self.state
    when "new"
      self.section.active_question = self
    when "active"
      self.update_attributes :state => "answered"
    when "answered"
      self.update_attributes :state => "finished"
    end
  end

  def reset_state
    self.transaction do
      Vote.delete_all :answer_variant_id => self.answer_variants.map(&:id)
      self.update_attributes :state => "new"
    end
  end

  def answered?
    self.answer_variants.joins(:anonymouss).count > 0
  end

  def voted_anonymous_count
    Anonymous.joins(:answer_variants).where('answer_variants.question_id' => self.id).uniq.map(&:id).uniq.count
  end

  def formated_answer_variants
    sum = 0.0
    self.answer_variants.each do |aw|
      sum += aw.votes.sum(:vote).to_f
    end
    self.answer_variants.map do |aw|
      votes = aw.votes.sum(:vote).to_f
      { :text => aw.text,
        :percent => if sum > 0; then (votes / sum) * 100; else 0; end}
    end
  end

  def voted_variants(anonymous)
    self.answer_variants.joins(:votes => :anonymous).where("anonymous.id" => anonymous).uniq
  end

  def question_answered?(anonymous)
    self.voted_variants(anonymous).first != nil
  end

  def kinds
    Question.validators_on(:kind).select do |v|
      v.kind_of? ActiveModel::Validations::InclusionValidator
    end.first.options[:in].collect do |k|
      [k, I18n.translate(k)]
    end
  end

  def states
    Question.validators_on(:state).select do |v|
      v.kind_of? ActiveModel::Validations::InclusionValidator
    end.first.options[:in].collect do |k|
      [k, I18n.translate(k)]
    end
  end

  private

  def set_defaults
    self.state ||= "new"
    self.kind ||= "radio"
  end
end
