require 'feed_tools'
class CachedBlogrollFeed < ActiveRecord::Base
  validates_presence_of :feed_uri, :parsed_feed
  validates_uniqueness_of :feed_uri
  serialize :parsed_feed, Hash # note that if this exceeds a certain KB size, it will likely fail (thinking it's a String)
end