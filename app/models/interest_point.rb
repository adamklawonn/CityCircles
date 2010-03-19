# == Schema Information
# Schema version: 20100319044343
#
# Table name: interest_points
#
#  id              :integer(4)      not null, primary key
#  map_id          :integer(4)      not null
#  map_layer_id    :integer(4)      not null
#  map_icon_id     :integer(4)      not null
#  label           :string(255)     not null
#  body            :string(255)
#  description     :string(255)
#  twitter_hashtag :string(255)
#  lat             :decimal(10, 6)
#  lng             :decimal(10, 6)
#  author_id       :integer(4)      not null
#  created_at      :datetime
#  updated_at      :datetime
#

class InterestPoint < ActiveRecord::Base
  belongs_to :map
  belongs_to :map_layer
  belongs_to :map_icon
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  has_many :comments, :as => :commentable
  acts_as_mappable :default_units => :miles, :default_formula => :sphere, :distance_field_name => :distance, :lat_column_name => :lat, :lng_column_name => :lng
  
  def to_s
    label
  end
  
  def name
    label
  end
  
end
