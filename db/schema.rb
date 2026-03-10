# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_10_121234) do
  create_table "focus_entries", force: :cascade do |t|
    t.boolean "achieved"
    t.text "ai_reflection"
    t.text "anticipated_blockers"
    t.datetime "created_at", null: false
    t.date "entry_date", null: false
    t.text "non_achievement_reason"
    t.text "primary_focus", null: false
    t.datetime "updated_at", null: false
    t.index ["entry_date"], name: "index_focus_entries_on_entry_date", unique: true
  end
end
