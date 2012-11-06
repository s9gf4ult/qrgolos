class Anonymous < ActiveRecord::Base
  after_initialize :set_defaults
  
  attr_accessible :active, :aid, :fake
  belongs_to :section
  validates :active, :aid, :fake, :presence => true
  validates :fake, :uniqueness => {:scope => [:section_id]}
  validates :aid, :uniqueness => true

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
    self.active ||= true
    self.aid ||= self.find_aid
    self.fake ||= false
  end
end
