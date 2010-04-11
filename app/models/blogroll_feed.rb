# == Schema Information
# Schema version: 20100410232227
#
# Table name: blogroll_feeds
#
#  id          :integer(4)      not null, primary key
#  feed_name   :string(255)     not null
#  feed_uri    :string(255)     not null
#  created_at  :datetime
#  updated_at  :datetime
#  parsed_feed :text
#

class BlogrollFeed < ActiveRecord::Base
  serialize :parsed_feed, FeedNormalizer::Feed
end
