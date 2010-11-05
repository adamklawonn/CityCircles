# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def generate_profile_gmap( map, poi_override = nil, poi_override_options = {} )
    
    poi_override_options[ :open_info_window_onload ] = false unless poi_override_options.has_key?( :open_info_window_onload )
    
    if poi_override != nil
      poi_override_marker = GMarker.new [ poi_override.lat, poi_override.lng ], :title => poi_override.label, :info_window => poi_override.body
    end
    
    marker_groups = []
    line_groups = []
    map.map_layers.each do | layer |
      case layer.shortname
        when "lightrailline"
          line_categories = InterestLine.find( :all, :group => "shortname", :conditions => [ "map_layer_id = ?", layer.id ] )
          marker_group = { :layer_name => layer.shortname, :markers => layer.interest_points.collect { | poi | GMarker.new( [ poi.lat, poi.lng ], :icon => GIcon.new( :image => poi.map_icon.image_url, :icon_size => GSize.new( 20, 20 ), :icon_anchor => GPoint.new( 10, 10 ), :info_window_anchor => GPoint.new( 10, 10 ) ), :title => ( ( !poi_override.nil? and poi.id == poi_override.id ) ? poi_override.label : poi.label ), :info_window => ( ( !poi_override.nil? and poi.id == poi_override.id ) ? poi_override.body : poi.body ) ) } }
          line_categories.each do | lc | 
            marker_group[ :markers ] << GPolyline.new( InterestLine.find( :all, :select => "lat, lng", :conditions => [ "shortname = ?", lc.shortname ] ).collect { | poi | [ poi.lat, poi.lng ] }, "#FFFFFF", 9, 1 )
            marker_group[ :markers ] << GPolyline.new( InterestLine.find( :all, :select => "lat, lng", :conditions => [ "shortname = ?", lc.shortname ] ).collect { | poi | [ poi.lat, poi.lng ] }, "#8F2323", 5, 1 )
          end
          marker_groups << marker_group
          
        else
          marker_group = { :layer_name => layer.shortname, :markers => layer.recent_posts( layer.id, layer.shortname ).collect { | poi | GMarker.new( [ poi.lat, poi.lng ], { :icon => GIcon.new( :image => poi.post_type.map_icon.image_url, :icon_size => GSize.new( poi.post_type.map_icon.icon_size.split( "," )[ 0 ].to_i, poi.post_type.map_icon.icon_size.split( "," )[ 1 ].to_i ), :shadow => poi.post_type.map_icon.shadow_url, :shadow_size => GSize.new( poi.post_type.map_icon.shadow_size.split( "," )[ 0 ].to_i, poi.post_type.map_icon.shadow_size.split( "," )[ 1 ].to_i ), :icon_anchor => GPoint.new( poi.post_type.map_icon.icon_anchor.split( "," )[ 0 ].to_i, poi.post_type.map_icon.icon_anchor.split( "," )[ 1 ].to_i ), :info_window_anchor => GPoint.new( poi.post_type.map_icon.info_window_anchor.split( "," )[ 0 ].to_i, poi.post_type.map_icon.info_window_anchor.split( "," )[ 1 ].to_i ) ), :title => poi.label, :info_window => poi.info_window } ) } }
          marker_groups << marker_group
        
      end
    end
    
    # Initialize the map.
    gmap = GMap.new( "map", "map" )
    gmap.control_init( :large_map => true, :map_type => true )
    
    # Set location based on map default or poi override.
    if poi_override.nil?
      gmap.center_zoom_init( [ map.lat, map.lng ], map.zoom )
      gmap.record_init "map.enableScrollWheelZoom();"
    else
      gmap.center_zoom_init( [ poi_override.lat, poi_override.lng ], 15 )
      gmap.record_init "map.openInfoWindowHtml( new GLatLng( #{ poi_override.lat }, #{ poi_override.lng }, true ), '#{ poi_override.body }' );" if poi_override_options[ :open_info_window_onload ]
      gmap.record_init "map.enableScrollWheelZoom();" if poi_override_options[ :enable_scroll_zoom ]
    end
    
    # Add markers to each individual layer on the map.
    marker_groups.each do | mg |
      gmap.overlay_global_init GMarkerGroup.new( true, mg[:markers] ), mg[:layer_name]
    end
    
    gmap
    
  end

  def generate_gmap( map, poi_override = nil, poi_override_options = {} )
    poi_override_options[ :open_info_window_onload ] = false unless poi_override_options.has_key?( :open_info_window_onload )
    
    if poi_override != nil
      poi_override_marker = GMarker.new [ poi_override.lat, poi_override.lng ], :title => poi_override.label, :info_window => poi_override.body
    end
    
    marker_groups = []
    line_groups = []
    #Pathfinder edit
    #Create a storage for a complete list of POIs
    poi_collection = CompleteMarkerCollection.new
    
    map.map_layers.each do | layer |
      case layer.shortname
        when "lightrailline"
          line_categories = InterestLine.find( :all, :group => "shortname", :conditions => [ "map_layer_id = ?", layer.id ] )
          marker_group = { :layer_name => layer.shortname, 
                           :markers => layer.interest_points.collect { | poi | GMarker.new( [ poi.lat, poi.lng ], :icon => GIcon.new( :image => poi.map_icon.image_url, :icon_size => GSize.new( 20, 20 ), :icon_anchor => GPoint.new( 10, 10 ), :info_window_anchor => GPoint.new( 10, 10 ) ), :title => ( ( !poi_override.nil? and poi.id == poi_override.id ) ? poi_override.label : poi.label ), :info_window => ( ( !poi_override.nil? and poi.id == poi_override.id ) ? poi_override.body : poi.body ) ) } }
          line_categories.each do | lc | 
            marker_group[ :markers ] << GPolyline.new( InterestLine.find( :all, 
                :select => "lat, lng", 
                :conditions => [ "shortname = ?", lc.shortname ] ).collect { | poi | [ poi.lat, poi.lng ] }, "#FFFFFF", 9, 1 )
            marker_group[ :markers ] << GPolyline.new( InterestLine.find( :all, :select => "lat, lng", :conditions => [ "shortname = ?", lc.shortname ] ).collect { | poi | [ poi.lat, poi.lng ] }, "#8F2323", 5, 1 )
          end
          marker_groups << marker_group
          
          #Pathfinder edit
          #Add markers to cc_poi_list
          #deprecated
          #poi_collection.addMarkersToCollection(marker_group => :markers)
          
        else
          marker_group = { :layer_name => layer.shortname, :markers => layer.recent_posts( layer.id, layer.shortname ).collect { | poi | GMarker.new( [ poi.lat, poi.lng ], { :icon => GIcon.new( :image => poi.post_type.map_icon.image_url, :icon_size => GSize.new( poi.post_type.map_icon.icon_size.split( "," )[ 0 ].to_i, poi.post_type.map_icon.icon_size.split( "," )[ 1 ].to_i ), :shadow => poi.post_type.map_icon.shadow_url, :shadow_size => GSize.new( poi.post_type.map_icon.shadow_size.split( "," )[ 0 ].to_i, poi.post_type.map_icon.shadow_size.split( "," )[ 1 ].to_i ), :icon_anchor => GPoint.new( poi.post_type.map_icon.icon_anchor.split( "," )[ 0 ].to_i, poi.post_type.map_icon.icon_anchor.split( "," )[ 1 ].to_i ), :info_window_anchor => GPoint.new( poi.post_type.map_icon.info_window_anchor.split( "," )[ 0 ].to_i, poi.post_type.map_icon.info_window_anchor.split( "," )[ 1 ].to_i ) ), :title => poi.label, :info_window => poi.info_window } ) } }
          marker_groups << marker_group
          
          #Pathfinder
          #Add markers to poi_collection if there is something to add
          markers = marker_group[:markers]
          n = markers.length
         # debugger
          if n != 0
            poi_collection.addMarkersToCollection(marker_group[:markers])
          end  
          
      end
      
    end
    # Initialize the map.
    gmap = GMap.new( "map", "map" )

    #Pathfinder
    #Make all POIs availabe to JavaScript
    #deprecated
    #gmap.record_global_init "\nvar complete_poi_list = #{ poi_collection.poi_list.to_json };\n"
    gmap.control_init( :large_map => true, :map_type => true )

    
    # Set location based on map default or poi override.
    if poi_override.nil?
      gmap.center_zoom_init( [ map.lat, map.lng ], map.zoom )
      gmap.record_init "map.enableScrollWheelZoom();"
    else
      gmap.center_zoom_init( [ poi_override.lat, poi_override.lng ], 15 )
      gmap.record_init "map.openInfoWindowHtml( new GLatLng( #{ poi_override.lat }, #{ poi_override.lng }, true ), '#{ poi_override.body }' );" if poi_override_options[ :open_info_window_onload ]
      gmap.record_init "map.enableScrollWheelZoom();" if poi_override_options[ :enable_scroll_zoom ]
    end
    
    # Add markers to each individual layer on the map.
    marker_groups.each do | mg |
      #gmap.overlay_global_init GMarkerGroup.new( true, mg[:markers] ), mg[:layer_name]
      if mg[:layer_name] == "lightrailline"
        # clusterer = Clusterer.new(mg[:markers])
        # gmap.overlay_global_init clusterer, mg[:layer_name]
        gmap.overlay_global_init GMarkerGroup.new( true, mg[:markers] ), mg[:layer_name]
      end
    end
    #debugger
    
    clusterer = Clusterer.new(poi_collection.poi_list)
    gmap.overlay_global_init clusterer, "one_layer"

    gmap
    
  end
  
  # The map for the interest point (places) page.
  def generate_poi_gmap( poi )
    
    if poi.class.class_name == "InterestPoint"
      poi.body = "<strong>#{ poi.label }</strong><br /><br />You have jumped to this place."
      pmap = self.generate_gmap( poi.map, poi, { :open_info_window_onload => true, :enable_scroll_zoom => true } )
    end
    
    pmap
    
  end
  
  # The little map inside the post content dialog.
  def generate_poi_post_map( poi )
    
    post_gmap = GMap.new( "postcontentmap", "postcontentmap" )
    post_gmap.control_init :small_map => true, :map_type => true
    post_gmap.center_zoom_init( [ poi.lat, poi.lng ], 15 )
    post_gmap.overlay_init GMarker.new( [ poi.lat, poi.lng ], :icon => GIcon.new( :image => poi.map_icon.image_url, :icon_size => GSize.new( 20, 20 ), :icon_anchor => GPoint.new( 10, 10 ), :info_window_anchor => GPoint.new( 10, 10 ) ) )
    post_gmap.record_init "poiBounds = GCircle( postcontentmap, new GLatLng( #{ poi.lat }, #{ poi.lng } ), new GLatLng( #{ poi.lat } + 0.004166666666667, #{ poi.lng } ), '#000000', '#79AB75' );"
    post_gmap.record_init "latlngMarker = null;"
    post_gmap.record_init "GEvent.addListener( postcontentmap, 'click', function( overlay, latlng, overlaylatlng ) {
    document.getElementById('address_field').value = ''; 
    if( overlaylatlng != undefined ) { 
      $( 'lat' ).value = overlaylatlng.lat();
      $( 'lng' ).value = overlaylatlng.lng();
      $( 'location-msg' ).appear(); 
    } else{
      alert('Please make a selection within the green radius.');
    } 
} );"
    post_gmap.record_init "GEvent.addListener( postcontentmap, 'click', function( overlay, latlng, overlaylatlng ) { 
    if( overlaylatlng != undefined ) { 
      if( latlngMarker == null ) { 
        latlngMarker = new GMarker( new GLatLng( overlaylatlng.lat(), overlaylatlng.lng() ) );
        postcontentmap.addOverlay( latlngMarker ); 
      }else { 
        latlngMarker.setLatLng( new GLatLng( overlaylatlng.lat(), overlaylatlng.lng() ) );
      } 
    }  
} );"
    post_gmap.record_init "postcontentmap.enableScrollWheelZoom();
    postcontentmap.getDragObject().setDraggableCursor( 'pointer' );
    postcontentmap.savePosition();
    postcontentmap.addOverlay( poiBounds ); 
    postcontentmap.returnToSavedPosition();"
    
    post_gmap
    
  end
  
  def friendly_datetime( datetime )
    datetime.strftime( "%a, %b %d, %Y %I:%M %p" )
  end
  
  def commentable_url
    commentable = controller.controller_name.singularize
    comments_path( :commentable_type => commentable, :commentable_id => controller.instance_variable_get( "@#{ commentable }" ).id )
  end
  
  #Pathfinder edit
  class CompleteMarkerCollection
     
     def initialize
       @poi_list = []
     end 
     def poi_list
       @poi_list
     end
     
     def addMarkersToCollection( markers )
       markers.each do | marker |
         poi_list.push(marker)
       end
     end
  end  
  
end
