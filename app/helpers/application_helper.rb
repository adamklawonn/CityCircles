# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def generate_gmap( map, poi_override = nil, poi_override_options = {} )
    
    poi_override_options[ :open_info_window_onload ] = false unless poi_override_options.has_key?( :open_info_window_onload )
    
    if poi_override != nil
      poi_override_marker = GMarker.new [ poi_override.lat, poi_override.lng ], :title => poi_override.label, :info_window => poi_override.body
    end
    
    marker_groups = []
    line_groups = []
    map.map_layers.each do | layer |
      case layer.shortname
        when "lightrailline"
          line_categories = InterestLine.find_by_sql "select distinct shortname from interest_lines where map_layer_id = #{ layer.id }"
          marker_group = { :layer_name => layer.shortname, :markers => layer.interest_points.collect { | poi | GMarker.new( [ poi.lat, poi.lng ], :icon => GIcon.new( :image => poi.map_icon.image_url, :icon_size => GSize.new( 20, 20 ), :icon_anchor => GPoint.new( 10, 10 ), :info_window_anchor => GPoint.new( 10, 10 ) ), :title => ( ( !poi_override.nil? and poi.id == poi_override.id ) ? poi_override.label : poi.label ), :info_window => ( ( !poi_override.nil? and poi.id == poi_override.id ) ? poi_override.body : poi.body ) ) } }
          line_categories.each do | lc | 
            marker_group[ :markers ] << GPolyline.new( InterestLine.find( :all, :conditions => [ "shortname = ?", lc.shortname ] ).collect { | poi | [ poi.lat, poi.lng ] }, "#8F2323", 5, 0.5 )
          end
          marker_groups << marker_group
          
        when "news"
          line_categories = InterestLine.find_by_sql "select distinct shortname from interest_lines where map_layer_id = #{ layer.id }"
          marker_group = { :layer_name => layer.shortname, :markers => layer.news.collect { | poi | GMarker.new( [ poi.lat, poi.lng ], :icon => GIcon.new( :image => poi.map_icon.image_url, :icon_size => GSize.new( poi.map_icon.icon_size.split( "," )[ 0 ].to_i, poi.map_icon.icon_size.split( "," )[ 1 ].to_i ), :shadow => poi.map_icon.shadow_url, :shadow_size => GSize.new( poi.map_icon.shadow_size.split( "," )[ 0 ].to_i, poi.map_icon.shadow_size.split( "," )[ 1 ].to_i ), :icon_anchor => GPoint.new( poi.map_icon.icon_anchor.split( "," )[ 0 ].to_i, poi.map_icon.icon_anchor.split( "," )[ 1 ].to_i ), :info_window_anchor => GPoint.new( poi.map_icon.info_window_anchor.split( "," )[ 0 ].to_i, poi.map_icon.info_window_anchor.split( "," )[ 1 ].to_i ) ), :title => poi.label, :info_window => poi.body ) } }
          line_categories.each do | lc | 
            marker_group[ :markers ] << GPolyline.new( InterestLine.find( :all, :conditions => [ "shortname = ?", lc.shortname ] ).collect { | poi | [ poi.lat, poi.lng ] }, "#8F2323", 5, 0.5 )
          end
          marker_groups << marker_group
      end
    end
    
    # Initialize the map.
    gmap = GMap.new( "map", "map" )
    gmap.control_init( :large_map => true, :map_type => true )
    gmap.record_init "map.enableScrollWheelZoom();"
    
    # Set location based on map default or poi override.
    if poi_override.nil?
      gmap.center_zoom_init( [ map.lat, map.lng ], map.zoom )
    else
      gmap.center_zoom_init( [ poi_override.lat, poi_override.lng ], 15 )
      gmap.record_init "map.openInfoWindowHtml( new GLatLng( #{ poi_override.lat }, #{ poi_override.lng }, true ), '#{ poi_override.body }' );" if poi_override_options[ :open_info_window_onload ]
    end
    
    # Add markers to each individual layer on the map.
    marker_groups.each do | mg |
      gmap.overlay_global_init GMarkerGroup.new( true, mg[:markers] ), mg[:layer_name]
    end
    
    gmap
    
  end
  
  def generate_poi_gmap( poi )
    
    if poi.class.class_name == "InterestPoint"
      poi.body = "<strong>#{ poi.label }</strong><br /><br />You have jumped to this place."
      pmap = self.generate_gmap( poi.map, poi, { :open_info_window_onload => true } )
    end
    
    pmap
    
  end
  
  def generate_poi_post_map( poi )
    
    post_gmap = GMap.new( "postcontentmap", "postcontentmap" )
    post_gmap.control_init :small_map => true, :map_type => true
    post_gmap.center_zoom_init( [ poi.lat, poi.lng ], 15 )
    post_gmap.overlay_init GMarker.new( [ poi.lat, poi.lng ], :icon => GIcon.new( :image => poi.map_icon.image_url, :icon_size => GSize.new( 20, 20 ), :icon_anchor => GPoint.new( 10, 10 ), :info_window_anchor => GPoint.new( 10, 10 ) ) )
    post_gmap
    
  end
  
end
