class Vote < ActiveRecord::Base
  attr_accessible :vote

  belongs_to :anonymous
  belongs_to :answer_variant

  validates :vote, :presence => true
  validates_each :vote do |record, attr, value|
    question = record.answer_variant.question
    anonymous = record.anonymous
    if anonymous.section != question.section
      record.errors.add(:answer_variant, (I18n.translate "votes.wrong-section"))
    end
  end
end
