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

ActiveRecord::Schema[7.1].define(version: 2024_11_25_064700) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contributions", force: :cascade do |t|
    t.integer "amount"
    t.date "date"
    t.boolean "paid"
    t.bigint "investment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["investment_id"], name: "index_contributions_on_investment_id"
  end

  create_table "etfs", force: :cascade do |t|
    t.string "name"
    t.string "ticker_symbol"
    t.string "category"
    t.string "description"
    t.string "historical_data"
    t.integer "current_price"
    t.float "average_return"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "etf_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["etf_id"], name: "index_favorites_on_etf_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "investments", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "user_id", null: false
    t.bigint "etf_id", null: false
    t.string "risk_level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["etf_id"], name: "index_investments_on_etf_id"
    t.index ["user_id"], name: "index_investments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "contributions", "investments"
  add_foreign_key "favorites", "etfs"
  add_foreign_key "favorites", "users"
  add_foreign_key "investments", "etfs"
  add_foreign_key "investments", "users"
end
