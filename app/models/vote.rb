class Vote < ActiveRecord::Base
  attr_accessible :anonymous_id, :answer_variant_id, :vote
end
