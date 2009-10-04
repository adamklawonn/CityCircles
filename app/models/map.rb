# == Schema Information
# Schema version: 20091004012535
#
# Table name: maps
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)     not null
#  description :string(255)     not null
#  shortname   :string(255)     not null
#  lat         :decimal(10, 6)  not null
#  lng         :decimal(10, 6)  not null
#  zoom        :integer(4)      default(0)
#  author_id   :integer(4)      not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Map < ActiveRecord::Base
    
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  has_many :map_layers
  has_many :interest_points
  has_many :comments, :as => :commenter
  
  def self.generate_gmap( map )
    
    marker_groups = []
    map.map_layers.each do | layer |
      marker_groups << { :layer_name => layer.shortname, :markers => layer.interest_points.collect { | poi | GMarker.new( [ poi.lat, poi.lng ], :title => poi.label, :info_window => "<strong>#{ poi.label }</strong><br /><a href='places/#{ poi.id }'>Jump to this place</a>" ) } }
    end
    gmap = GMap.new( "map" )
    gmap.control_init( :large_map => true, :map_type => true )
    gmap.center_zoom_init( [ map.lat, map.lng ], map.zoom )
    marker_groups.each do | mg |
      gmap.overlay_global_init GMarkerGroup.new( true, mg[:markers] ), mg[:layer_name]
    end
    
    gmap
    
  end
  
end
