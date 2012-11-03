class AnswerVariant < ActiveRecord::Base
  attr_accessible :position, :text

  belongs_to :question
  validates :position, :text, :presence => true
  validates :text, :uniqueness => {:scope => [:question_id]}
  validates :position, :uniqueness => {:scope => [:question_id]}
end
