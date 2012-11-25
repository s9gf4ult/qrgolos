class AddIndexesToVotes < ActiveRecord::Migration
  def change
    add_index :votes, :anonymous_id
    add_index :votes, :answer_variant_id
    add_index :votes, :vote
  end
end
