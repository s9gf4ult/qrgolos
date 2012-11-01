class Question < ActiveRecord::Base
  attr_accessible :kind, :question, :section_id, :state
end
