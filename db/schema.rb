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

ActiveRecord::Schema.define(version: 20160517193058) do

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

  create_table "departures", force: :cascade do |t|
    t.integer  "year"
    t.integer  "month"
    t.integer  "day_of_month"
    t.integer  "day_of_week"
    t.integer  "dep_time"
    t.integer  "crs_dep_time"
    t.integer  "arr_time"
    t.integer  "crs_arr_time"
    t.string   "unique_carrier",      limit: 6
    t.integer  "flight_num"
    t.string   "tail_num",            limit: 8
    t.integer  "actual_elapsed_time"
    t.integer  "crs_elapsed_time"
    t.integer  "air_time"
    t.integer  "arr_delay"
    t.integer  "dep_delay"
    t.string   "origin",              limit: 3
    t.string   "dest",                limit: 3
    t.integer  "distance"
    t.integer  "taxi_in"
    t.integer  "taxi_out"
    t.boolean  "cancelled"
    t.string   "cancellation_code",   limit: 1
    t.boolean  "diverted"
    t.integer  "carrier_delay"
    t.integer  "weather_delay"
    t.integer  "nas_delay"
    t.integer  "security_delay"
    t.integer  "late_aircraft_delay"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "departures", ["cancelled"], name: "index_departures_on_cancelled", using: :btree
  add_index "departures", ["dest"], name: "index_departures_on_dest", using: :btree
  add_index "departures", ["origin"], name: "index_departures_on_origin", using: :btree
  add_index "departures", ["unique_carrier"], name: "index_departures_on_unique_carrier", using: :btree
  add_index "departures", ["year"], name: "index_departures_on_year", using: :btree

  add_foreign_key "departures", "airports", column: "dest", primary_key: "iata"
  add_foreign_key "departures", "airports", column: "origin", primary_key: "iata"
  add_foreign_key "departures", "carriers", column: "unique_carrier", primary_key: "code"
end
