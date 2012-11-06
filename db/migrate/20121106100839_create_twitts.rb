class CreateTwitts < ActiveRecord::Migration
  def change
    create_table :twitts do |t|
      t.integer :anonymous_id
      t.string :state
      t.text :text

      t.timestamps
    end
  end
end
