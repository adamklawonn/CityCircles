# == Schema Information
# Schema version: 20091128210317
#
# Table name: posts
#
#  id                :integer(4)      not null, primary key
#  post_type_id      :integer(4)      not null
#  interest_point_id :integer(4)      not null
#  map_layer_id      :integer(4)      not null
#  lat               :decimal(10, 6)
#  lng               :decimal(10, 6)
#  headline          :string(255)     not null
#  short_headline    :string(255)     not null
#  body              :text            default(""), not null
#  author_id         :integer(4)      not null
#  created_at        :datetime
#  updated_at        :datetime
#

class Post < ActiveRecord::Base
  
  belongs_to :post_type
  belongs_to :interest_point
  belongs_to :map_layer
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  has_one :event
  has_one :tweet
  has_many :comments, :as => :commentable
  
  acts_as_mappable :default_units => :miles, :default_formula => :sphere, :distance_field_name => :distance, :lat_column_name => :lat, :lng_column_name => :lng
  
  # Label for map.
  def label
    short_headline
  end
  
  # Info window.
  def info_window
    headline
  end
  
end
