class Section < ActiveRecord::Base
  attr_accessible :name, :anonymous_count, :descr, :screens_count
  has_many :questions, :dependent => :destroy
  has_many :anonymouss, :dependent => :destroy
  has_many :screens, :order => "id asc"
  belongs_to :meeting
  validates :name, :presence => true
  validates :name, :uniqueness => {:scope => :meeting_id}

  def screens_count
    self.screens.count
  end

  def screens_count=(count)
    count = count.to_i
    if count >= 0
      if self.screens_count < count
        (count - self.screens_count).times do
          self.screens.create
        end
      elsif self.screens_count > count
        self.screens.reorder("id desc").limit(self.screens_count - count).each do |s|
          s.destroy
        end
      end
    end
  end

  def answered_questions
    Enumerator.new do |en|
      self.questions.where(:state => 'finished').each do |question|
        if question.answered?
          en.yield question
        end
      end
    end
  end

  def formated_twitts
    Enumerator.new do |en|
      self.twitts.each do |twitt|
        ret =  {
          name:  twitt.anonymous.formated_name,
          text:  twitt.text,
          state: twitt.state,
        }
        en.yield ret
      end
    end
  end

  def formated_active_twitts
    Enumerator.new do |en|
      self.active_twitts.each do |twitt|
        ret = {
          name:  twitt.anonymous.formated_name,
          text:  twitt.text,
          state: twitt.state,
        }
        en.yield ret
      end
    end
  end
  
  def twitts
    Twitt.joins(:anonymous => :section).where('anonymous.fake' => false, 'sections.id' => self.id).reorder('twitts.created_at desc')
  end
  
  def active_twitts
    Twitt.joins(:anonymous => :section).where('anonymous.fake' => false, 'sections.id' => self.id, 'twitts.state' => "active").reorder('twitts.created_at desc')
  end

  def statistics_question
    self.questions.where(:state => "statistics").first
  end

  def current_question
    self.showed_question || self.active_question || self.statistics_question
  end

  def active_question
    self.questions.where(:state => "active").first
  end

  def active_question=(question)
    if question == nil
      self.transaction do
        self.questions.where(:state => "active").each do |q|
          q.update_attributes :state => "finished", :countdown_to => nil
        end
      end
    elsif question.section == self and question.state != "active"
      self.transaction do
        self.questions.where(:state => ["active", "showed", "statistics"]).each do |q|
          if q.id != question.id
            q.update_attributes :state => (q.state == "showed" ? "new" : "finished"), :countdown_to => nil
          end
        end
        question.update_attributes :state => "active"
      end
    end
  end

  def showed_question
    self.questions.where(:state => "showed").first
  end

  def showed_question=(question)
    if question == nil
      self.transaction do
        self.questions.where(:state => "showed").each do |q|
          q.update_attributes :state => "new", :countdown_to => nil
        end
      end
    elsif question.section == self and question.state != "showed"
      self.transaction do
        self.questions.where(:state => ["active", "showed", "statistics"]).each do |q|
          if q.id != question.id
            q.update_attributes :state => (q.state == "showed" ? "new" : "finished"), :countdown_to => nil
          end
        end
        question.update_attributes :state => "showed"
      end
    end
  end

  def anonymous_count=(need)
    need = need.to_i
    need = 0 if need < 0
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
