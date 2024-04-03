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

ActiveRecord::Schema[7.1].define(version: 2024_04_03_081737) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "insurance_lines", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "risk_profile_id", null: false
    t.integer "risk_level", null: false
    t.string "line", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["risk_profile_id"], name: "index_insurance_lines_on_risk_profile_id"
  end

  create_table "insureds", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "age", null: false
    t.integer "income", null: false
    t.integer "dependents", null: false
    t.integer "house_ownership_status"
    t.boolean "married", null: false
    t.integer "base_risk", null: false
    t.integer "vehicle_year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "risk_profiles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "insured_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["insured_id"], name: "index_risk_profiles_on_insured_id"
  end

  add_foreign_key "insurance_lines", "risk_profiles"
  add_foreign_key "risk_profiles", "insureds"
end
