class CreateAnonymous < ActiveRecord::Migration
  def change
    create_table :anonymous do |t|
      t.integer :section_id
      t.string :aid
      t.boolean :fake
      t.boolean :active

      t.timestamps
    end
  end
end
