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

ActiveRecord::Schema.define(version: 20180227215334) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.bigint "event_id"
    t.string "place_name"
    t.string "street1"
    t.string "street2"
    t.string "city"
    t.string "state"
    t.string "post_code"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.index ["event_id"], name: "index_addresses_on_event_id"
  end

  create_table "attendances", force: :cascade do |t|
    t.bigint "attendee_id"
    t.bigint "attended_event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attended_event_id"], name: "index_attendances_on_attended_event_id"
    t.index ["attendee_id"], name: "index_attendances_on_attendee_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organizer_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "image"
    t.string "website"
    t.bigint "group_id"
    t.index ["group_id"], name: "index_events_on_group_id"
    t.index ["organizer_id"], name: "index_events_on_organizer_id"
  end

  create_table "group_memberships", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_memberships_on_group_id"
    t.index ["user_id"], name: "index_group_memberships_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "image"
    t.boolean "private"
    t.boolean "hidden"
    t.boolean "all_members_can_create_events"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_groups_on_user_id"
  end

  create_table "membership_requests", force: :cascade do |t|
    t.string "message"
    t.bigint "group_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_membership_requests_on_group_id"
    t.index ["user_id"], name: "index_membership_requests_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "location"
    t.string "bio"
  end

  add_foreign_key "events", "groups"
  add_foreign_key "group_memberships", "groups"
  add_foreign_key "group_memberships", "users"
  add_foreign_key "groups", "users"
  add_foreign_key "membership_requests", "groups"
  add_foreign_key "membership_requests", "users"
end
