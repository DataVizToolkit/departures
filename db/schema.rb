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

ActiveRecord::Schema.define(version: 20160517143601) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "airports", force: :cascade do |t|
    t.string   "iata",       limit: 4
    t.string   "airport"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.float    "lat"
    t.float    "long"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "airports", ["iata"], name: "index_airports_on_iata", unique: true, using: :btree

  create_table "carriers", force: :cascade do |t|
    t.string   "code",        limit: 7
    t.string   "description"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "carriers", ["code"], name: "index_carriers_on_code", unique: true, using: :btree

end
