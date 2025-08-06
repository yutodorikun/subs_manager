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

ActiveRecord::Schema[7.1].define(version: 2025_08_06_133007) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alternative_plans", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.string "name", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.string "billing_cycle", null: false
    t.text "features"
    t.string "plan_type", null: false
    t.string "company"
    t.string "service_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id", "plan_type"], name: "index_alternative_plans_on_category_id_and_plan_type"
    t.index ["category_id"], name: "index_alternative_plans_on_category_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "color", null: false
    t.string "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "category_id", null: false
    t.string "name", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.string "billing_cycle", null: false
    t.date "start_date", null: false
    t.string "payment_method"
    t.boolean "is_active", default: true
    t.string "service_url"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_subscriptions_on_category_id"
    t.index ["is_active"], name: "index_subscriptions_on_is_active"
    t.index ["user_id", "name"], name: "index_subscriptions_on_user_id_and_name"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "google_id", null: false
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["google_id"], name: "index_users_on_google_id", unique: true
  end

  add_foreign_key "alternative_plans", "categories"
  add_foreign_key "subscriptions", "categories"
  add_foreign_key "subscriptions", "users"
end
