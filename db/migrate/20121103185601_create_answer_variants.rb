class CreateAnswerVariants < ActiveRecord::Migration
  def change
    create_table :answer_variants do |t|
      t.integer :question_id
      t.string :text
      t.integer :position

      t.timestamps
    end
  end
end
