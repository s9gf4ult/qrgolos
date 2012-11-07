class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :anonymous_id
      t.integer :answer_variant_id
      t.integer :vote

      t.timestamps
    end
  end
end
