class AddIndexesToQuestions < ActiveRecord::Migration
  def change
    add_index :questions, :section_id
    add_index :questions, :question
    add_index :questions, :state
    add_index :questions, :kind
    add_index :questions, :countdown_to
  end
end
