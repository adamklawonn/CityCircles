# == Schema Information
# Schema version: 20091201065827
#
# Table name: tweets
#
#  id                :integer(4)      not null, primary key
#  post_id           :integer(4)      not null
#  tweet_id          :integer(8)
#  body              :string(255)
#  from_user         :string(255)
#  to_user           :string(255)
#  iso_language_code :string(255)
#  source            :string(255)
#  profile_image_url :string(255)
#  tweeted_at        :string(255)
#  location          :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

class Tweet < ActiveRecord::Base
  belongs_to :post
end
