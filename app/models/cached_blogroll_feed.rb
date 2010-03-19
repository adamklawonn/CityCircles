# == Schema Information
# Schema version: 20100319044343
#
# Table name: cached_blogroll_feeds
#
#  id          :integer(4)      not null, primary key
#  uri         :string(2048)
#  parsed_feed :text(16777215)
#  created_at  :datetime
#  updated_at  :datetime
#

class CachedBlogrollFeed < ActiveRecord::Base
  validates_presence_of :feed_uri, :parsed_feed
  validates_uniqueness_of :feed_uri
  serialize :parsed_feed, Hash # note that if this exceeds a certain KB size, it will likely fail (thinking it's a String)
end
