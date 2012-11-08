class Question < ActiveRecord::Base
  after_initialize :set_defaults
  
  attr_accessible :kind, :question, :state
  belongs_to :section
  has_many :answer_variants, :order => "position asc", :dependent => :destroy
  validates :question, :kind, :state, :presence => true
  validates :question, :uniqueness => {:scope => [:section_id]}
  validates :kind, :inclusion => {:in => %w(radio check stars)}
  validates :state, :inclusion => {:in => %w(new active answered canceled)}

  def voted_variants(anonymous)
    self.answer_variants.joins(:votes => :anonymous).where("anonymous.id" => anonymous)
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
