class AnswerVariant < ActiveRecord::Base
  attr_accessible :position, :text

  belongs_to :question
  validates :position, :text, :presence => true
  validates :text, :uniqueness => {:scope => [:question_id]}
  validates :position, :uniqueness => {:scope => [:question_id]}

  def bringup
    upper = self.question.answer_variants.where("position < ?", self.position).reorder("position desc").first
    if upper
      self.transaction do
        a = self.position
        b = upper.position
        self.update_attribute(:position, b)
        upper.update_attribute(:position, a)
        [self, upper].all? {|x| x.valid?} #  FIXME: rollback if false ?
      end
    else
      true
    end
  end

  def bringdown
    downer = self.question.answer_variants.where("position > ?", self.position).reorder("position asc").first
    if downer
      self.transaction do
        a = self.position
        b = downer.position
        self.update_attribute(:position, b)
        downer.update_attribute(:position, a)
        [self, downer].all? {|x| x.valid?} #  FIXME: rollback if false ?
      end
    else
      true
    end
  end

  def last_position
    lst = self.question.answer_variants.reorder("position desc").first
    if lst
      lst.position + 1
    else
      0
    end
  end
end
