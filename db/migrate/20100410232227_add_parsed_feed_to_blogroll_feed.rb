class AddParsedFeedToBlogrollFeed < ActiveRecord::Migration
  def self.up
    add_column :blogroll_feeds, :parsed_feed, :text, :default => nil
  end

  def self.down
    remove_column :blogroll_feeds, :parsed_feed
  end
end
