class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.string :name
      t.text :descr
      t.integer :user_id

      t.timestamps
    end
  end
end
