class Anonymous < ActiveRecord::Base
  after_initialize :set_defaults
  
  attr_accessible :active, :aid, :fake
  belongs_to :section
  validates :aid, :presence => true
  validates :aid, :uniqueness => true
  validates_each :fake do |record, attr, value|
    if value and record.section.anonymouss.where(:fake => true).first
      record.errors.add(attr, "Fake already exists in this section")
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

  private
  def set_defaults
    if self.active != false
      self.active = true
    end
    self.aid ||= self.find_aid
    self.fake ||= false
  end
end
