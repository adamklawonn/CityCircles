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

ActiveRecord::Schema.define(:version => 20101011180415) do

  create_table "acts_as_xapian_jobs", :force => true do |t|
    t.string  "model",    :null => false
    t.integer "model_id", :null => false
    t.string  "action",   :null => false
  end

  add_index "acts_as_xapian_jobs", ["model", "model_id"], :name => "index_acts_as_xapian_jobs_on_model_and_model_id", :unique => true

  create_table "ads", :force => true do |t|
    t.integer  "organization_id",                         :null => false
    t.string   "placement",                               :null => false
    t.datetime "starts_at",                               :null => false
    t.datetime "ends_at",                                 :null => false
    t.integer  "weight",               :default => 1
    t.string   "graphic_file_name",                       :null => false
    t.string   "graphic_content_type"
    t.integer  "graphic_file_size"
    t.datetime "graphic_updated_at"
    t.boolean  "is_approved",          :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "interest_point_id"
    t.string   "link_uri"
    t.text     "popup_html"
  end

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

  create_table "blogroll_categories", :force => true do |t|
    t.string   "name",                         :null => false
    t.boolean  "is_active",  :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blogroll_feeds", :force => true do |t|
    t.string   "feed_name",            :null => false
    t.string   "feed_uri",             :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "parsed_feed"
    t.integer  "blogroll_category_id", :null => false
  end

  create_table "cached_blogroll_feeds", :force => true do |t|
    t.string   "uri",         :limit => 2048
    t.text     "parsed_feed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.string   "title",            :null => false
    t.string   "body",             :null => false
    t.integer  "author_id",        :null => false
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_blast_templates", :force => true do |t|
    t.string   "name"
    t.string   "template_filename"
    t.boolean  "is_active",         :default => false
    t.integer  "author_id",                            :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_blasts", :force => true do |t|
    t.datetime "send_at"
    t.boolean  "is_active",      :default => false
    t.boolean  "was_sent",       :default => false
    t.string   "template",                          :null => false
    t.string   "subject",                           :null => false
    t.text     "body",                              :null => false
    t.integer  "author_id",                         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "blastable_id"
    t.string   "blastable_type"
  end

  create_table "events", :force => true do |t|
    t.integer  "post_id",    :null => false
    t.datetime "starts_at",  :null => false
    t.datetime "ends_at",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["post_id"], :name => "index_events_on_post_id"

  create_table "geometry_columns", :id => false, :force => true do |t|
    t.string  "f_table_catalog",   :limit => 256, :null => false
    t.string  "f_table_schema",    :limit => 256, :null => false
    t.string  "f_table_name",      :limit => 256, :null => false
    t.string  "f_geometry_column", :limit => 256, :null => false
    t.integer "coord_dimension",                  :null => false
    t.integer "srid",                             :null => false
    t.string  "type",              :limit => 30,  :null => false
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

  add_index "map_icons", ["shortname"], :name => "index_map_icons_on_shortname"

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

  create_table "organization_members", :force => true do |t|
    t.integer  "user_id",                           :null => false
    t.integer  "organization_id",                   :null => false
    t.boolean  "is_active",       :default => true
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

  create_table "post_attachments", :force => true do |t|
    t.integer  "post_id",                 :null => false
    t.string   "caption",                 :null => false
    t.string   "oembed"
    t.text     "code"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "post_types", :force => true do |t|
    t.string   "name",                                    :null => false
    t.integer  "map_layer_id",                            :null => false
    t.integer  "map_icon_id",                             :null => false
    t.string   "map_fill_color",   :default => "#000000"
    t.string   "map_stroke_color", :default => "#d3d3d3"
    t.integer  "map_stroke_width", :default => 2
    t.string   "shortname",                               :null => false
    t.string   "twitter_hashtag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.integer  "post_type_id",                                                                      :null => false
    t.integer  "interest_point_id",                                                                 :null => false
    t.integer  "map_layer_id",                                                                      :null => false
    t.boolean  "sticky",                                                         :default => false
    t.decimal  "lat",                             :precision => 10, :scale => 6
    t.decimal  "lng",                             :precision => 10, :scale => 6
    t.string   "headline",                                                                          :null => false
    t.string   "short_headline",    :limit => 40,                                                   :null => false
    t.text     "body",                                                                              :null => false
    t.integer  "author_id",                                                                         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_draft",                                                       :default => false
  end

  create_table "promos", :force => true do |t|
    t.integer  "organization_id",                    :null => false
    t.integer  "post_id",                            :null => false
    t.string   "title",                              :null => false
    t.integer  "author_id",                          :null => false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean  "is_approved",     :default => false
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

  create_table "spatial_ref_sys", :id => false, :force => true do |t|
    t.integer "srid",                      :null => false
    t.string  "auth_name", :limit => 256
    t.integer "auth_srid"
    t.string  "srtext",    :limit => 2048
    t.string  "proj4text", :limit => 2048
  end

  create_table "suggestions", :force => true do |t|
    t.string   "email",      :limit => 100,  :null => false
    t.string   "body",       :limit => 5000, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tweets", :force => true do |t|
    t.integer  "post_id",                        :null => false
    t.integer  "tweet_id",          :limit => 8
    t.string   "body"
    t.string   "from_user"
    t.string   "to_user"
    t.string   "iso_language_code"
    t.string   "source"
    t.string   "profile_image_url"
    t.string   "tweeted_at"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "typus_users", :force => true do |t|
    t.string   "first_name",       :default => "",    :null => false
    t.string   "last_name",        :default => "",    :null => false
    t.string   "role",                                :null => false
    t.string   "email",                               :null => false
    t.boolean  "status",           :default => false
    t.string   "token",                               :null => false
    t.string   "salt",                                :null => false
    t.string   "crypted_password",                    :null => false
    t.string   "preferences"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_details", :force => true do |t|
    t.integer  "user_id",             :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "twitter_username"
    t.text     "about_me"
    t.string   "employer"
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
    t.string   "login",                                                :null => false
    t.string   "email",                                                :null => false
    t.string   "crypted_password",                                     :null => false
    t.string   "password_salt",                                        :null => false
    t.string   "persistence_token",                                    :null => false
    t.string   "single_access_token",                                  :null => false
    t.string   "perishable_token",                                     :null => false
    t.integer  "login_count",                       :default => 0,     :null => false
    t.integer  "failed_login_count",                :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "roles",                             :default => ""
    t.boolean  "email_verified",                    :default => false
    t.boolean  "agreed_with_terms"
    t.integer  "facebook_uid",         :limit => 8
    t.string   "facebook_session_key"
  end

  create_table "wireless_carriers", :force => true do |t|
    t.string   "name"
    t.string   "email_gateway"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
