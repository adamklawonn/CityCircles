class CreateCachedBlogrollFeeds < ActiveRecord::Migration
  def self.up
    create_table :cached_blogroll_feeds, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :uri, :string, :limit => 2048
      t.column :parsed_feed, :text, :limit => 128.kilobytes # use for serialized object
      t.timestamps
    end
  end

  def self.down
    drop_table :cached_blogroll_feeds
  end
end
