class Anonymous < ActiveRecord::Base
  after_initialize :set_defaults

  attr_accessible :active, :aid, :fake, :name, :name_number
  belongs_to :section
  has_many :twitts, :dependent => :delete_all
  has_many :votes, :dependent => :delete_all
  has_many :answer_variants, :through => :votes

  validates :aid, :presence => true
  validates :aid, :uniqueness => true
  validates_each :fake do |record, attr, value|
    if value and record.section.anonymouss.where(:fake => true).first
      record.errors.add(attr, "Fake already exists in this section")
    end
  end
  #  FIXME: needs some kind of validation, this is not critical parameter, but
  # it must be fixed
  # validates :name_number, :uniqueness => {:scope => [:section_id, :name]}
  validates_each :name_number do |record, attr, value|
    if value != nil
      if Anonymous.where(:name => record.name, :name_number => value).first
        record.errors.add(attr, "Name and name number must be unique")
      end
    end
  end

  def formated_name
    if self.name.to_s.strip.length == 0
      name = I18n.translate 'anonymous.anonymous'
    else
      name = self.name
    end
    if self.name_number == 1
      name
    else
      "#{name} (#{self.name_number})"
    end
  end

  def find_aid
    def gen_numbers(count)
      count.times.collect {rand 10}.reduce do |a, b|
        a.to_s + b.to_s
      end
    end
    numbers = 6
    loop do
      10.times do
        x = gen_numbers(numbers)
        if Anonymous.where("aid = ?", x).first == nil
          return x
        end
      end
      numbers += 1
    end
  end

  def find_name_number
    an = Anonymous.where(:section_id => self.section.id, :name => self.name).reorder("name_number desc").first
    if an == nil
      1
    else
      an.name_number + 1
    end
  end

  def actuate_name_number
    if self.new_record?
      self.name_number = self.find_name_number
    else
      if self.name_number
        if Anonymous.where(:name => self.name, :name_number => self.name_number, :section_id => self.section.id).count > 1
          self.name_number = self.find_name_number
        end
      else
        self.name_number = self.find_name_number
      end
    end
  end

  private
  def set_defaults
    if self.active != false
      self.active = true
    end
    self.aid ||= self.find_aid
    self.fake ||= false
  end
end
