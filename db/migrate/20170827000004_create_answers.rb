# +SPEC+: <em>The answer to the question is always Yes or No.</em>
class CreateAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :answers do |t|
      t.boolean :yes_no,        null: false
      t.integer :survey_id,     null: false
      t.index   :survey_id
      t.integer :respondent_id, null: false
      t.index   :respondent_id
      # +SPEC+: <em>You should keep track of when each of the survey responses are saved.</em>
      t.timestamps
    end
  end
end
