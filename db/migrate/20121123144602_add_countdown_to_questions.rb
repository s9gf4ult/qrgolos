class AddCountdownToQuestions < ActiveRecord::Migration
  def change
    change_table :questions do |t|
      t.timestamp :countdown_to
    end
  end
end
