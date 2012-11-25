class AddIndexesToAnonymous < ActiveRecord::Migration
  def change
    add_index :anonymous, :section_id
    add_index :anonymous, :aid, :unique => true
    add_index :anonymous, :active
    add_index :anonymous, :fake
    add_index :anonymous, :name
    add_index :anonymous, :name_number
  end
end
