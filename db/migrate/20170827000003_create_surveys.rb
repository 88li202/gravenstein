# +SPEC+: <em>A survey consists of one question represented as a single string.</em>
# +SPEC+: <em>A user should be able to create any number of surveys.</em>
class CreateSurveys < ActiveRecord::Migration[5.1]
  def change
    create_table :surveys do |t|
      t.boolean :is_active,   null: false, default: true
      t.index   :is_active
      t.integer :result_id
      t.integer :surveyor_id, null: false
      t.index   :surveyor_id
      t.string  :question,    null: false
      t.timestamps
    end
  end
end
