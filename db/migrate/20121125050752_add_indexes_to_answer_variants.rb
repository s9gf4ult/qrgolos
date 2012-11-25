class AddIndexesToAnswerVariants < ActiveRecord::Migration
  def change
    add_index :answer_variants, :question_id
    add_index :answer_variants, :position
    add_index :answer_variants, :text
  end
end
