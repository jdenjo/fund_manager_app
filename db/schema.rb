# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_04_09_002747) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "funds", force: :cascade do |t|
    t.string "name"
    t.text "strategy"
    t.float "AUM"
    t.datetime "inception"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_funds_on_user_id"
  end

  create_table "positions", force: :cascade do |t|
    t.string "ticker"
    t.datetime "termination"
    t.bigint "user_id"
    t.bigint "fund_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fund_id"], name: "index_positions_on_fund_id"
    t.index ["user_id"], name: "index_positions_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "shares"
    t.string "ticker"
    t.float "price"
    t.string "status"
    t.text "reason"
    t.bigint "position_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position_id"], name: "index_transactions_on_position_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.boolean "admin", default: false
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "funds", "users"
  add_foreign_key "positions", "funds"
  add_foreign_key "transactions", "positions"
end