class AddNameToAnonymous < ActiveRecord::Migration
  def change
    change_table :anonymous do |t|
      t.text :name
      t.integer :name_number
    end
  end
end
