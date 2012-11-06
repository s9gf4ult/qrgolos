class Section < ActiveRecord::Base
  attr_accessible :name
  has_many :questions
  has_many :anonymouss
  belongs_to :meeting
  validates :name, :presence => true
  validates :name, :uniqueness => {:scope => :meeting_id}

  def set_active_anonymous_count(need)
    self.transaction do 
      active_count = self.anonymouss.where(:active => true).count
      all_count = self.anonymouss.count
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

  private
  def generate_anonymous(cnt)
    cnt.times do
      self.anonymouss.create
    end
  end

  def deactivate_anonymous(cnt)
    self.anonymouss.where(:active => true).reorder("id desc").limit(cnt).each do |x|
      x.update_attribute(:active, false)
    end
  end

  def activate_anonymous(cnt)
    self.anonymouss.where(:active => false).reorder("id asc").limit(cnt).each do |x|
      x.update_attribute(:active, true)
    end
  end
end
