class AddDescToSections < ActiveRecord::Migration
  def change
    add_column :sections, :desc, :text
  end
end
