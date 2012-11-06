class Twitt < ActiveRecord::Base
  after_initialize :set_defaults

  attr_accessible :state, :text

  belongs_to :anonymous
  validates :state, :text, :presence => true
  validates :state, :inclusion => {:in => %w(new canceled active)}

  def states
    Twitt.validators_on(:state).select do |v|
      v.kind_of? ActiveModel::Validations::InclusionValidator
    end.first.options[:in].collect do |k|
      [k, I18n.translate(k)]
    end
  end

  private
  def set_defaults
    self.state ||= "new"
  end
end
