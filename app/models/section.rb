class Section < ActiveRecord::Base
  attr_accessible :name, :anonymous_count, :descr
  has_many :questions, :dependent => :destroy
  has_many :anonymouss, :dependent => :destroy
  belongs_to :meeting
  validates :name, :presence => true
  validates :name, :uniqueness => {:scope => :meeting_id}

  def twitts
    Twitt.joins(:anonymous => :section).where('anonymous.fake' => false, 'sections.id' => self.id).reorder('twitts.created_at asc')
  end
  
  def active_twitts
    Twitt.joins(:anonymous => :section).where('anonymous.fake' => false, 'sections.id' => self.id, 'twitts.state' => "active").reorder('twitts.created_at asc')
  end

  def active_question
    self.questions.where(:state => "active").first
  end

  def active_question=(question)
    if question == nil or (question.section == self and question.state != "active")
      self.transaction do
        self.questions.where(:state => "active").each do |q|
          q.update_attribute(:state, "answered")
        end
        if question
          question.update_attribute(:state, "active")
        end
      end
    end
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
