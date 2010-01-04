class InterestPointsController < ApplicationController
  
  #uses_tiny_mce
  
  def show
    @poi = InterestPoint.find( params[ :id ] )
    @default_map = @poi.map
    
    @news = Post.find( :all, :conditions => [ 'post_type_id = ? and interest_point_id = ?', 1, @poi.id ], :origin => [ @poi.lat, @poi.lng ], :within => 0.3, :order => "posts.sticky desc, posts.created_at desc", :limit => 8 )
    @events = Post.find( :all, :conditions => [ 'post_type_id = ? and interest_point_id = ?', 2, @poi.id ], :origin => [ @poi.lat, @poi.lng ], :within => 0.3, :order => "posts.sticky desc, posts.created_at desc", :limit => 8 )
    @networks = Post.find( :all, :conditions => [ 'post_type_id = ? and interest_point_id = ?', 3, @poi.id ], :origin => [ @poi.lat, @poi.lng ], :within => 0.3, :order => "posts.sticky desc, posts.created_at desc", :limit => 8 )
    @stuffs = Post.find( :all, :conditions => [ 'post_type_id = ? and interest_point_id = ?', 5, @poi.id ], :origin => [ @poi.lat, @poi.lng ], :within => 0.3, :order => "posts.sticky desc, posts.created_at desc", :limit => 8 )
    @fix_its = Post.find( :all, :conditions => [ 'post_type_id = ? and interest_point_id = ?', 6, @poi.id ], :origin => [ @poi.lat, @poi.lng ], :within => 0.3, :order => "posts.sticky desc, posts.created_at desc", :limit => 8 )
    
  end
  
  def add_content
    
    @poi = InterestPoint.find( params[ :poi_id ] )
    
    if request.xhr?
      
      content_types = { :news => PostType.find_by_shortname( "news" ), :event => PostType.find_by_shortname( "events" ), :promo => PostType.find_by_shortname(  "promos" ), :network => PostType.find_by_shortname( "network" ), :stuff => PostType.find_by_shortname( "stuff" ), :fix_it => PostType.find_by_shortname( "fixit" ) }
      content_type = params[ :content_type ]
      
      if content_types.has_key? content_type.to_sym
      
        render :update do | page |
          page.replace_html "postcontentform", :partial => "posts/form", :locals => { :post => Post.new, :post_type => content_types[ content_type.to_sym ], :poi => @poi }
          page << "$j( '#postcontent' ).dialog( 'open' );$j( '#postcontent' ).dialog( 'option', 'position', [ 'center', 'center' ] );"
          page << "$j( '#ui-dialog-title-postcontent' ).html( 'Post #{ content_type.camelize }' );"
          page << "if( poiBounds == null ) {"
          page << "poiBounds = GCircle( postcontentmap, new GLatLng( #{ @poi.lat }, #{ @poi.lng } ), new GLatLng( #{ @poi.lat } + 0.004166666666667, #{ @poi.lng } ), '#000000', '#79AB75' );"
          page << "latlngMarker = null;"
          page << "GEvent.addListener( postcontentmap, 'click', function( overlay, latlng, overlaylatlng ) { if( overlaylatlng != undefined ) { $( 'poi_bounds_latitude' ).value = overlaylatlng.lat();$( 'poi_bounds_longitude' ).value = overlaylatlng.lng();$( 'lat' ).value = overlaylatlng.lat();$( 'lng' ).value = overlaylatlng.lng(); } } );"
          page << "GEvent.addListener( postcontentmap, 'click', function( overlay, latlng, overlaylatlng ) { if( overlaylatlng != undefined ) { if( latlngMarker == null ) { latlngMarker = new GMarker( new GLatLng( overlaylatlng.lat(), overlaylatlng.lng() ) );postcontentmap.addOverlay( latlngMarker ); } else { latlngMarker.setLatLng( new GLatLng( overlaylatlng.lat(), overlaylatlng.lng() ) ) } } } );"
          page << "postcontentmap.enableScrollWheelZoom();"
          page << "postcontentmap.getDragObject().setDraggableCursor( 'pointer' );"
          page << "postcontentmap.savePosition();"
          page << "$j( '#postcontent' ).bind( 'dialogbeforeclose', function (event, ui ) { tinyMCE.execCommand( 'mceRemoveControl', false, 'post_body' ); } );"
          page << "}"
          page << "postcontentmap.addOverlay( poiBounds );"
          page << "postcontentmap.returnToSavedPosition();"
          page << 'tinyMCE.execCommand( "mceAddControl", false, "post_body" );'
        end
        
      end
      
    end
    
  end
  
  def add_universal_content
    
    if request.xhr?
      
      @poi = InterestPoint.find( params[ :poi_id ] )
      
      render :update do | page |
         page.redirect_to interest_point_url( @poi, :content_type => params[ :content_type ] )
      end
    end
    
  end
  
end
