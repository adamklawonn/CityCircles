class CreateCachedBlogrollFeeds < ActiveRecord::Migration
  def self.up
    create_table :cached_blogroll_feeds do |t|
      t.column :uri, :string, :limit => 2048
      t.column :parsed_feed, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :cached_blogroll_feeds
  end
end
