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

ActiveRecord::Schema.define(:version => 20091128210317) do

  create_table "assets", :force => true do |t|
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "attachings_count",  :default => 0
    t.datetime "created_at"
    t.datetime "data_updated_at"
  end

  create_table "attachings", :force => true do |t|
    t.integer  "attachable_id"
    t.integer  "asset_id"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attachings", ["asset_id"], :name => "index_attachings_on_asset_id"
  add_index "attachings", ["attachable_id"], :name => "index_attachings_on_attachable_id"

  create_table "comments", :force => true do |t|
    t.string   "title",            :null => false
    t.string   "body",             :null => false
    t.integer  "author_id",        :null => false
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.integer  "post_id",    :null => false
    t.datetime "starts_at",  :null => false
    t.datetime "ends_at",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "file_attachments", :force => true do |t|
    t.string   "file_attachment_file_name",    :null => false
    t.string   "file_attachment_content_type", :null => false
    t.integer  "file_attachment_file_size",    :null => false
    t.integer  "file_attachable_id"
    t.string   "file_attachable_type"
    t.integer  "author_id",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hobbies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interest_lines", :force => true do |t|
    t.integer  "map_id",                                      :null => false
    t.integer  "map_layer_id",                                :null => false
    t.string   "label",                                       :null => false
    t.string   "shortname",                                   :null => false
    t.string   "description"
    t.decimal  "lat",          :precision => 10, :scale => 6
    t.decimal  "lng",          :precision => 10, :scale => 6
    t.integer  "author_id",                                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interest_lines", ["map_id"], :name => "index_interest_lines_on_map_id"
  add_index "interest_lines", ["map_layer_id"], :name => "index_interest_lines_on_map_layer_id"
  add_index "interest_lines", ["shortname"], :name => "index_interest_lines_on_shortname"

  create_table "interest_points", :force => true do |t|
    t.integer  "map_id",                                         :null => false
    t.integer  "map_layer_id",                                   :null => false
    t.integer  "map_icon_id",                                    :null => false
    t.string   "label",                                          :null => false
    t.string   "body"
    t.string   "description"
    t.string   "twitter_hashtag"
    t.decimal  "lat",             :precision => 10, :scale => 6
    t.decimal  "lng",             :precision => 10, :scale => 6
    t.integer  "author_id",                                      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interest_points", ["map_icon_id"], :name => "index_interest_points_on_map_icon_id"
  add_index "interest_points", ["map_id"], :name => "index_interest_points_on_map_id"
  add_index "interest_points", ["map_layer_id"], :name => "index_interest_points_on_map_layer_id"

  create_table "interests", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "map_icons", :force => true do |t|
    t.string   "shortname",                              :null => false
    t.string   "image_url",                              :null => false
    t.string   "icon_size",                              :null => false
    t.string   "shadow_url"
    t.string   "shadow_size"
    t.string   "icon_anchor",        :default => "0, 0"
    t.string   "info_window_anchor", :default => "0, 0"
    t.integer  "author_id",                              :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "map_layers", :force => true do |t|
    t.integer  "map_id",      :null => false
    t.string   "title",       :null => false
    t.string   "shortname",   :null => false
    t.string   "description"
    t.integer  "author_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "map_layers", ["map_id"], :name => "index_map_layers_on_map_id"

  create_table "maps", :force => true do |t|
    t.string   "title",                                                     :null => false
    t.string   "description",                                               :null => false
    t.string   "shortname",                                                 :null => false
    t.decimal  "lat",         :precision => 10, :scale => 6,                :null => false
    t.decimal  "lng",         :precision => 10, :scale => 6,                :null => false
    t.integer  "zoom",                                       :default => 0
    t.integer  "author_id",                                                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", :force => true do |t|
    t.integer  "interest_point_id",                                :null => false
    t.string   "name",                                             :null => false
    t.string   "description"
    t.integer  "author_id",                                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "lat",               :precision => 10, :scale => 6
    t.decimal  "lng",               :precision => 10, :scale => 6
  end

  create_table "pages", :force => true do |t|
    t.string   "title",                                 :null => false
    t.string   "shortname",                             :null => false
    t.boolean  "show_in_navigation", :default => false
    t.string   "description"
    t.text     "body"
    t.integer  "sort",               :default => 1
    t.integer  "author_id",                             :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["show_in_navigation"], :name => "index_pages_on_show_in_navigation"

  create_table "post_types", :force => true do |t|
    t.string   "name",            :null => false
    t.integer  "map_icon_id",     :null => false
    t.string   "shortname",       :null => false
    t.string   "twitter_hashtag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.integer  "post_type_id",                                     :null => false
    t.integer  "interest_point_id",                                :null => false
    t.integer  "map_layer_id",                                     :null => false
    t.decimal  "lat",               :precision => 10, :scale => 6
    t.decimal  "lng",               :precision => 10, :scale => 6
    t.string   "headline",                                         :null => false
    t.string   "short_headline",                                   :null => false
    t.text     "body",                                             :null => false
    t.integer  "author_id",                                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "promos", :force => true do |t|
    t.integer  "organization_id", :null => false
    t.integer  "post_id",         :null => false
    t.string   "title",           :null => false
    t.string   "description",     :null => false
    t.integer  "author_id",       :null => false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "site_options", :force => true do |t|
    t.string   "name"
    t.string   "option_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "suggestions", :force => true do |t|
    t.string   "email",      :limit => 100,  :null => false
    t.string   "body",       :limit => 5000, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tweets", :force => true do |t|
    t.integer  "post_id",           :null => false
    t.integer  "tweet_id",          :null => false
    t.string   "body",              :null => false
    t.string   "from_user",         :null => false
    t.string   "to_user"
    t.string   "iso_language_code"
    t.string   "source"
    t.string   "profile_image_url"
    t.string   "tweeted_at",        :null => false
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_details", :force => true do |t|
    t.integer  "user_id",             :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "about_me"
    t.string   "hobbies"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "user_hobbies", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "hobby_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_interests", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.integer  "interest_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_locations", :force => true do |t|
    t.integer  "user_id",           :null => false
    t.integer  "interest_point_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_wireless_profiles", :force => true do |t|
    t.integer  "user_id",                               :null => false
    t.string   "wireless_carrier_id"
    t.string   "wireless_number"
    t.string   "subscriptions"
    t.boolean  "digest",              :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                               :null => false
    t.string   "email",                               :null => false
    t.string   "crypted_password",                    :null => false
    t.string   "password_salt",                       :null => false
    t.string   "persistence_token",                   :null => false
    t.string   "single_access_token",                 :null => false
    t.string   "perishable_token",                    :null => false
    t.integer  "login_count",         :default => 0,  :null => false
    t.integer  "failed_login_count",  :default => 0,  :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "roles",               :default => ""
  end

  create_table "wireless_carriers", :force => true do |t|
    t.string   "name"
    t.string   "email_gateway"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
