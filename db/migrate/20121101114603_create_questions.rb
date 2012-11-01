class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :section_id
      t.string :question
      t.string :state
      t.string :kind

      t.timestamps
    end
  end
end
