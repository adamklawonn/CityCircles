ActiveRecord::Schema.define(:version => 0) do
  create_table "mock_essays", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "assets_count", :default => 0
  end

  create_table "mock_photo_essays", :force => true do |t|
    t.string   "title"
    t.text     "body"
  end

  create_table "assets", :force => true do |t|
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "attachings_count", :default => 0
    t.datetime "created_at"
    t.datetime "data_updated_at"
    t.integer  "account_id"
  end

  add_index "assets", ["data_file_name"], :name => "index_assets_on_data_file_name", :unique => true

  create_table "attachings", :force => true do |t|
    t.integer  "attachable_id"
    t.integer  "asset_id"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
end
