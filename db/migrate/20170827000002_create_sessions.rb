class CreateSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.index :session_id, unique: true
      t.timestamps
    end
  end
end
