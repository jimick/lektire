class AddHintToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :hint, :text
  end
end
