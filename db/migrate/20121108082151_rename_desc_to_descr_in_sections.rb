class RenameDescToDescrInSections < ActiveRecord::Migration
  def change
    change_table :sections do |t|
      t.rename :desc, :descr
    end
  end
end
