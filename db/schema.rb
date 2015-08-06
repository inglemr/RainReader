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

ActiveRecord::Schema.define(version: 20150806132510) do

  create_table "s_classes", force: :cascade do |t|
    t.string   "CRN"
    t.string   "Course"
    t.string   "Title"
    t.string   "Campus"
    t.string   "Credits"
    t.string   "StartDate"
    t.string   "EndDate"
    t.string   "Days"
    t.string   "Time"
    t.string   "Location"
    t.string   "Instructor"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "open"
    t.string   "open_seats"
    t.string   "tot_seats"
    t.string   "term"
    t.string   "course_num"
    t.string   "course_code"
    t.string   "lab_time"
    t.string   "lab_loc"
    t.string   "loc_prof"
    t.string   "lab_day"
  end

  add_index "s_classes", ["user_id", "created_at"], name: "index_s_classes_on_user_id_and_created_at"
  add_index "s_classes", ["user_id"], name: "index_s_classes_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",           default: false
    t.string   "gswid"
    t.string   "gswpin"
    t.datetime "classUpdateTime"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
