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
    if question.kind == "radio"
      if question.voted_variants(anonymous).first
        record.errors.add(:answer_variant, (I18n.translate "votes.already-voted"))
      end
    end
    if ["radio", "check"].include? question.kind
      if value != 1
        record.errors.add(attr, (I18n.translate "votes.wrong-vote-value"))
      end
    end
  end
end
