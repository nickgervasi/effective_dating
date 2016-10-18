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

ActiveRecord::Schema.define(version: 20160928061011) do

  create_table "consultants", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
  end

  create_table "dated_relationships", force: :cascade do |t|
    t.string  "owner_type"
    t.integer "owner_id"
    t.date    "effect_from"
    t.date    "effect_to"
    t.string  "feature_type"
    t.integer "feature_id"
    t.string  "key"
    t.string  "type"
    t.index ["effect_from"], name: "index_dated_relationships_on_effect_from"
    t.index ["effect_to"], name: "index_dated_relationships_on_effect_to"
    t.index ["owner_type", "owner_id", "key"], name: "index_dated_relationships_on_owner_type_and_owner_id_and_key"
  end

  create_table "hourly_rates", force: :cascade do |t|
    t.integer "consultant_id"
    t.decimal "amount"
    t.index ["consultant_id"], name: "index_hourly_rates_on_consultant_id"
  end

  create_table "projects", force: :cascade do |t|
    t.integer "consultant_id"
    t.string  "name"
    t.string  "client"
    t.index ["consultant_id"], name: "index_projects_on_consultant_id"
  end

end
