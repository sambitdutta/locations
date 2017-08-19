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

ActiveRecord::Schema.define(version: 20170819175036) do

  create_table "follows", force: :cascade do |t|
    t.integer  "followable_id",   limit: 4,                   null: false
    t.string   "followable_type", limit: 255,                 null: false
    t.integer  "follower_id",     limit: 4,                   null: false
    t.string   "follower_type",   limit: 255,                 null: false
    t.boolean  "blocked",                     default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follows", ["followable_id", "followable_type"], name: "fk_followables", using: :btree
  add_index "follows", ["follower_id", "follower_type"], name: "fk_follows", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.decimal  "latitude",               precision: 63, scale: 10
    t.decimal  "longitude",              precision: 63, scale: 10
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "type",       limit: 255
  end

  add_index "locations", ["id", "type"], name: "index_locations_on_id_and_type", using: :btree
  add_index "locations", ["user_id"], name: "index_locations_on_user_id", using: :btree

  create_table "share_models", force: :cascade do |t|
    t.integer "resource_id",      limit: 4
    t.string  "resource_type",    limit: 255
    t.integer "shared_to_id",     limit: 4
    t.string  "shared_to_type",   limit: 255
    t.integer "shared_from_id",   limit: 4
    t.string  "shared_from_type", limit: 255
    t.boolean "edit"
  end

  add_index "share_models", ["resource_type", "resource_id"], name: "index_share_models_on_resource_type_and_resource_id", using: :btree
  add_index "share_models", ["shared_from_type", "shared_from_id"], name: "index_share_models_on_shared_from_type_and_shared_from_id", using: :btree
  add_index "share_models", ["shared_to_type", "shared_to_id"], name: "index_share_models_on_shared_to_type_and_shared_to_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "username",               limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "locations", "users"
end
