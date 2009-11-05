# == Schema Information
# Schema version: 20091104061546
#
# Table name: events
#
#  id                :integer(4)      not null, primary key
#  interest_point_id :integer(4)      not null
#  map_layer_id      :integer(4)      not null
#  map_icon_id       :integer(4)      not null
#  lat               :decimal(10, 6)
#  lng               :decimal(10, 6)
#  headline          :string(255)     not null
#  body              :string(5000)    not null
#  starts_at         :datetime        not null
#  ends_at           :datetime        not null
#  author_id         :integer(4)      not null
#  created_at        :datetime
#  updated_at        :datetime
#

class Event < ActiveRecord::Base
  belongs_to :interest_point
  belongs_to :map_layer
  belongs_to :map_icon
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  has_many :comments, :as => :commentable
  acts_as_mappable :default_units => :miles, :default_formula => :sphere, :distance_field_name => :distance, :lat_column_name => :lat, :lng_column_name => :lng
  
  def label 
    headline
  end
  
  def info_window
    "<strong>#{ headline }</strong><br /><br />#{ body[ 0..50 ] }<br /><strong>When:</strong><p>#{ starts_at.strftime( "%a %b %d, %Y %I:%M %p" ) }  -  #{ ends_at.strftime( "%a %b %d, %Y %I:%M %p" ) }</p><br />"
  end
  
end
