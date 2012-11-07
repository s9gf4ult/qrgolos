class Section < ActiveRecord::Base
  attr_accessible :name, :anonymous_count
  has_many :questions
  has_many :anonymouss
  belongs_to :meeting
  validates :name, :presence => true
  validates :name, :uniqueness => {:scope => :meeting_id}

  def active_question
    self.questions.where(:active => true).first
  end

  def anonymous_count=(need)
    need = need.to_i
    self.transaction do 
      active_count = self.anonymous_count
      all_count = self.anonymouss.where(:fake => false).count
      if active_count > need
        deactivate_anonymous active_count - need
      elsif active_count < need
        if all_count >= need
          activate_anonymous need - active_count
        else
          activate_anonymous all_count - active_count
          generate_anonymous need - all_count
        end
      end
    end
  end

  def anonymous_count
    self.anonymouss.where(:fake => false, :active => true).count
  end

  private
  def generate_anonymous(cnt)
    cnt.times do
      self.anonymouss.create
    end
  end

  def deactivate_anonymous(cnt)
    self.anonymouss.where(:fake => false, :active => true).reorder("id desc").limit(cnt).each do |x|
      x.update_attribute(:active, false)
    end
  end

  def activate_anonymous(cnt)
    self.anonymouss.where(:fake => false, :active => false).reorder("id asc").limit(cnt).each do |x|
      x.update_attribute(:active, true)
    end
  end
end
