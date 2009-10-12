class InterestPointsController < ApplicationController
  
  def show
    @poi = InterestPoint.find( params[ :id ] )
    @default_map = @poi.map
    
    @news = News.find( :all, :conditions => [ 'interest_point_id = ?', @poi.id ], :origin => [ @poi.lat, @poi.lng ], :within => 0.3, :order => 'created_at desc', :limit => 6 )
     @events = Event.find( :all, :conditions => [ 'interest_point_id = ?', @poi.id ], :origin => [ @poi.lat, @poi.lng ], :within => 0.3, :order => 'created_at desc', :limit => 6 )
     @networks = Network.find( :all, :conditions => [ 'interest_point_id = ?', @poi.id ], :origin => [ @poi.lat, @poi.lng ], :within => 0.3, :order => 'created_at desc', :limit => 6 )
     @stuffs = Stuff.find( :all, :conditions => [ 'interest_point_id = ?', @poi.id ], :origin => [ @poi.lat, @poi.lng ], :within => 0.3, :order => 'created_at desc', :limit => 6 )
     @fix_its = FixIt.find( :all, :conditions => [ 'interest_point_id = ?', @poi.id ], :origin => [ @poi.lat, @poi.lng ], :within => 0.3, :order => 'created_at desc', :limit => 6 )
  end
  
  def add_content
    
    @poi = InterestPoint.find( params[ :poi_id ] )
    
    if request.xhr?
      
      content_types = { :news => News, :event => Event, :promo => Promo, :network => Network, :stuff => Stuff, :fix_it => FixIt }
      content_type = params[ :content_type ]
      if content_types.has_key? content_type.to_sym
        render :update do | page |
          page.replace_html "postcontentform", :partial => "#{ content_type.pluralize }/#{ content_type }", :locals => { content_type.to_sym => eval( "content_types[ content_type.to_sym ].new" ), :poi => @poi }
          page << "$j( '#postcontent' ).dialog( 'option', 'position', [ 'center', 'center' ] );$j( '#postcontent' ).dialog( 'open' );"
          page << "$j( '#postcontent' ).dialog( 'option', 'modal', true );"
          page << "$j( '#ui-dialog-title-postcontent' ).html( 'Post #{ content_type.camelize }' );"
          page << "CCTinyMCEManager.makeInstance( '#{ content_type }_body' );"
          page << "$j( '##{ content_type }_submit' ).click( function() { $( '#{ content_type }_body' ).innerHTML =  tinyMCE.activeEditor.getContent(); } );"
          page << "$j( '#postcontent' ).bind( 'dialogbeforeclose', function( event, ui ) { CCTinyMCEManager.destroyInstance( '#{ content_type }_body' ); } );"
          page << "if( poiBounds == null ) {"
          page << "poiBounds = GCircle( postcontentmap, new GLatLng( #{ @poi.lat }, #{ @poi.lng } ), new GLatLng( #{ @poi.lat } + 0.004166666666667, #{ @poi.lng } ), '#000000', '#79AB75' );"
          page << "latlngMarker = null;"
          page << "GEvent.addListener( postcontentmap, 'click', function( overlay, latlng, overlaylatlng ) { if( overlaylatlng != undefined ) { $( 'poi_bounds_latitude' ).value = overlaylatlng.lat();$( 'poi_bounds_longitude' ).value = overlaylatlng.lng();$( 'lat' ).value = overlaylatlng.lat();$( 'lng' ).value = overlaylatlng.lng(); } } );"
          page << "GEvent.addListener( postcontentmap, 'click', function( overlay, latlng, overlaylatlng ) { if( overlaylatlng != undefined ) { if( latlngMarker == null ) { latlngMarker = new GMarker( new GLatLng( overlaylatlng.lat(), overlaylatlng.lng() ) );postcontentmap.addOverlay( latlngMarker ); } else { latlngMarker.setLatLng( new GLatLng( overlaylatlng.lat(), overlaylatlng.lng() ) ) } } } );"
          page << "postcontentmap.enableScrollWheelZoom();"
          page << "postcontentmap.getDragObject().setDraggableCursor( 'pointer' );"
          page << "postcontentmap.savePosition();"
          page << "} else {"
          page << "postcontentmap.removeOverlay( poiBounds );"
          page << "poiBounds = GCircle( postcontentmap, new GLatLng( #{ @poi.lat }, #{ @poi.lng } ), new GLatLng( #{ @poi.lat }, #{ @poi.lng } + 0.004166666666667 ), '#000000', '#79AB75' );"
          page << "}"
          page << "postcontentmap.addOverlay( poiBounds );"
          page << "postcontentmap.returnToSavedPosition();"
        end
      end
      
    end
    
  end
  
end
