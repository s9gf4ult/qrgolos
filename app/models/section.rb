class Section < ActiveRecord::Base
  attr_accessible :name
  has_many :questions
  belongs_to :meeting
  validates :name, :presence => true
  validates :name, :uniqueness => {:scope => :meeting_id}
end
