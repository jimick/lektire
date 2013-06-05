class AddCompletedSurveyToUsers < ActiveRecord::Migration
  def change
    add_column :schools, :completed_survey, :boolean, default: false
    add_column :students, :completed_survey, :boolean, default: false
  end
end
