class CreateFocusEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :focus_entries do |t|
      t.date :entry_date, null: false
      t.text :primary_focus, null: false
      t.text :anticipated_blockers
      t.boolean :achieved
      t.text :non_achievement_reason
      t.text :ai_reflection

      t.timestamps
    end

    add_index :focus_entries, :entry_date, unique: true
  end
end
