class Screen < ActiveRecord::Base
  attr_accessible :state

  belongs_to :section
end
