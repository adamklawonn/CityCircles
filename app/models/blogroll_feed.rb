# == Schema Information
# Schema version: 20100524015823
#
# Table name: blogroll_feeds
#
#  id               :integer(4)      not null, primary key
#  feed_name        :string(255)     not null
#  feed_uri         :string(255)     not null
#  created_at       :datetime
#  updated_at       :datetime
#  parsed_feed      :text
#  blog_category_id :integer(4)      not null
#

class BlogrollFeed < ActiveRecord::Base
  belongs_to :blogroll_category
  serialize :parsed_feed, FeedNormalizer::Feed
end
