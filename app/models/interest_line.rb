# == Schema Information
# Schema version: 20100524015823
#
# Table name: interest_lines
#
#  id           :integer(4)      not null, primary key
#  map_id       :integer(4)      not null
#  map_layer_id :integer(4)      not null
#  label        :string(255)     not null
#  shortname    :string(255)     not null
#  description  :string(255)
#  lat          :decimal(10, 6)
#  lng          :decimal(10, 6)
#  author_id    :integer(4)      not null
#  created_at   :datetime
#  updated_at   :datetime
#

class InterestLine < ActiveRecord::Base
  belongs_to :map
  belongs_to :map_layer
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  acts_as_mappable :default_units => :miles, :default_formula => :sphere, :distance_field_name => :distance, :lat_column_name => :lat, :lng_column_name => :lng
  
  def self.gmap_json(map_id = nil)
    # Query db for interest lines and return lat and lng only.
    # We'll then return an array of only lat and lng pairs.
    pois = self.connection.select_all("select lat, lng, shortname, map_layer_id from interest_lines where map_id = " + self.sanitize_sql(map_id))
    pois.collect { |poi| [poi['shortname'], poi['lat'], poi['lng'], poi['map_layer_id']] }
  end
  
end
