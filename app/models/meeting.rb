class Meeting < ActiveRecord::Base
  attr_accessible :descr, :name
  has_many :sections, :dependent => :delete_all
  belongs_to :user
  validates :name, :presence => true
  validates :name, :uniqueness => true 
end
