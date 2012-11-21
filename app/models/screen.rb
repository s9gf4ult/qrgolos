class Screen < ActiveRecord::Base
  after_initialize :set_defaults
  attr_accessible :state

  belongs_to :section
  validates :state, :inclusion => {:in => %w( banner twitts question statistics )}

  def states
    Screen.validators_on(:state).select do |v|
      v.kind_of? ActiveModel::Validations::InclusionValidator
    end.first.options[:in].collect do |k|
      [k, I18n.translate(k)]
    end
  end

  def rev_states
    self.states.map do |a, b|
      [b, a]
    end
  end

  private
  def set_defaults
    self.state ||= "banner"
  end
end
