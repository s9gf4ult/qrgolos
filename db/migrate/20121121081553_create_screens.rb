class CreateScreens < ActiveRecord::Migration
  def change
    create_table :screens do |t|
      t.integer :section_id
      t.string :state

      t.timestamps
    end
  end
end
