class Question < ActiveRecord::Base
  before_save :deactivate_others
  
  attr_accessible :kind, :question, :state
  belongs_to :section
  has_many :answer_variants, :order => "position asc"
  validates :question, :kind, :state, :presence => true
  validates :question, :uniqueness => {:scope => [:section_id]}
  validates :kind, :inclusion => {:in => %w(radio check stars)}
  validates :state, :inclusion => {:in => %w(new active answered canceled)}

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

  def deactivate_others
    if self.state == "active"
      self.section.questions.where(:state => "active").each do |q|
        if q != self
          q.state = "answered"
          q.save
        end
      end
    end
  end


end
