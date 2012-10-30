class Meeting < ActiveRecord::Base
  attr_accessible :descr, :name
  belongs_to :user
  validates :name, :presence => true
  validates :name, :uniqueness => true 
end
