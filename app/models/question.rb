class Question < ActiveRecord::Base
  after_initialize :set_defaults
  
  attr_accessible :kind, :question, :state
  belongs_to :section
  has_many :answer_variants, :order => "position asc", :dependent => :destroy
  validates :question, :kind, :state, :presence => true
  validates :question, :uniqueness => {:scope => [:section_id]}
  validates :kind, :inclusion => {:in => %w(radio check stars)}
  validates :state, :inclusion => {:in => %w(new active answered canceled)}

  def answered?
    self.answer_variants.joins(:anonymouss).count > 0
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
    self.answer_variants.joins(:votes => :anonymous).where("anonymous.id" => anonymous)
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
