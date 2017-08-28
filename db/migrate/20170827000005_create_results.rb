class CreateResults < ActiveRecord::Migration[5.1]
  def change
    create_table :results do |t|
      t.text    :answers_by_age_groups, null: false
      t.integer :answers_count,         null: false
      t.integer :percentage_yes,        null: false
      t.integer :survey_id,             null: false
      t.timestamps
    end
  end
end
