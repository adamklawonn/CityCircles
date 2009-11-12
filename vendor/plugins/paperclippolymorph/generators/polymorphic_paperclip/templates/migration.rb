class <%= migration_name %> < ActiveRecord::Migration
  def self.up
    create_table "assets" do |t|
      t.string   "data_file_name"
      t.string   "data_content_type"
      t.integer  "data_file_size"
      t.integer  "attachings_count", :default => 0
      t.datetime "created_at"
      t.datetime "data_updated_at"
    end
    
    create_table "attachings" do |t|
      t.integer  "attachable_id"
      t.integer  "asset_id"
      t.string   "attachable_type"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    add_index "attachings", ["asset_id"], :name => "index_attachings_on_asset_id"
    add_index "attachings", ["attachable_id"], :name => "index_attachings_on_attachable_id"
  end
  
  def self.down
    drop_table :assets
    drop_table :attachings
  end
end