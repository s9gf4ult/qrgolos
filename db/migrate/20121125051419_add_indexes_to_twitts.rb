class AddIndexesToTwitts < ActiveRecord::Migration
  def change
    add_index :twitts, :anonymous_id
    add_index :twitts, :state
    add_index :twitts, :text
    add_index :twitts, :created_at
  end
end
