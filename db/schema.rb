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

ActiveRecord::Schema.define(version: 20150720110157) do

  create_table "accounting_entries", force: :cascade do |t|
    t.date     "book_date"
    t.decimal  "amount"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "account_id"
    t.integer  "accounting_transaction_id"
  end

  add_index "accounting_entries", ["account_id"], name: "index_accounting_entries_on_account_id"
  add_index "accounting_entries", ["accounting_transaction_id"], name: "index_accounting_entries_on_accounting_transaction_id"

  create_table "accounting_transactions", force: :cascade do |t|
    t.date     "book_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "accounts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.string   "category"
  end

end
