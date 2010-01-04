# == Schema Information
# Schema version: 20100104062711
#
# Table name: post_types
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)     not null
#  map_layer_id    :integer(4)      not null
#  map_icon_id     :integer(4)      not null
#  shortname       :string(255)     not null
#  twitter_hashtag :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class PostType < ActiveRecord::Base
  belongs_to :map_layer
  belongs_to :map_icon
  has_many :posts
end
