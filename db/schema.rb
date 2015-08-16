# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150815144329) do

  create_table "balances", force: :cascade do |t|
    t.decimal  "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "on"
    t.integer  "user_id"
  end

  add_index "balances", ["user_id"], name: "index_balances_on_user_id"

  create_table "transfers", force: :cascade do |t|
    t.decimal  "amount"
    t.integer  "user_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.boolean  "outgoing"
    t.string   "reference"
    t.datetime "on"
    t.integer  "recurrence", default: 1
  end

  add_index "transfers", ["user_id"], name: "index_transfers_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "username",   null: false
  end

end
