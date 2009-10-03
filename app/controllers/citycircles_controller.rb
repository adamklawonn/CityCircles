class CitycirclesController < ApplicationController
  
  def index
    @user_session = ( current_user_session.nil? ? UserSession.new : current_user_session )
    @default_map = Map.find_by_shortname( "lightrail" )
    marker_groups = []
    @default_map.map_layers.each do | layer |
      marker_groups << { :layer_name => layer.shortname, :markers => layer.interest_points.collect { | poi | GMarker.new( [ poi.lat, poi.lng ], :title => poi.label, :info_window =>  ) } }
    end
    @map = GMap.new( "map" )
    @map.control_init( :large_map => true, :map_type => true )
    @map.center_zoom_init( [ @default_map.lat, @default_map.lng ], @default_map.zoom )
    marker_groups.each do | mg |
      @map.overlay_global_init GMarkerGroup.new( true, mg[:markers] ), mg[:layer_name]
    end
  end
  
end
