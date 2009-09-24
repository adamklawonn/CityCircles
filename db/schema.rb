# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090921083414) do

  create_table "comments", :force => true do |t|
    t.string   "title",          :null => false
    t.string   "body",           :null => false
    t.integer  "author_id",      :null => false
    t.integer  "commenter_id"
    t.string   "commenter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "headline",   :null => false
    t.string   "body",       :null => false
    t.datetime "starts_at",  :null => false
    t.datetime "ends_at",    :null => false
    t.integer  "author_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interest_points", :force => true do |t|
    t.string   "label",       :null => false
    t.string   "description"
    t.float    "lat"
    t.float    "lng"
    t.integer  "author_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "maps", :force => true do |t|
    t.string   "title",       :null => false
    t.string   "description", :null => false
    t.integer  "author_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", :force => true do |t|
    t.string   "headline",   :null => false
    t.string   "body",       :null => false
    t.integer  "author_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.string   "title",              :null => false
    t.string   "caption"
    t.string   "photo_file_name",    :null => false
    t.string   "photo_content_type", :null => false
    t.integer  "photo_file_size",    :null => false
    t.integer  "photoable_id"
    t.string   "photoable_type"
    t.integer  "author_id",          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "promos", :force => true do |t|
    t.string   "title",       :null => false
    t.string   "description", :null => false
    t.integer  "author_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_profiles", :force => true do |t|
    t.string   "first_name", :null => false
    t.string   "last_name",  :null => false
    t.string   "about_me"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_wireless_profiles", :force => true do |t|
    t.integer  "user_profile_id",                    :null => false
    t.string   "wireless_carrier"
    t.string   "wireless_number"
    t.string   "subscriptions"
    t.boolean  "digest",           :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                              :null => false
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "roles"
  end

end
