class Meeting < ActiveRecord::Base
  attr_accessible :descr, :name, :user_id
end
