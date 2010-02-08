class CreateBlogrollFeeds < ActiveRecord::Migration
  def self.up
    create_table :blogroll_feeds do |t|
      t.string :feed_name, :null => false
      t.string :feed_uri, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :blogroll_feeds
  end
end
