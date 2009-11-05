class CitycirclesController < ApplicationController
  
  def index
    @default_map = Map.find_by_shortname( "lightrail", :include => [ { :map_layers => [ { :news => :map_icon }, { :events => :map_icon }, { :networks => :map_icon }, { :stuffs => :map_icon }, { :fix_its => :map_icon } ] } ] )
    @user_session = ( current_user_session.nil? ? UserSession.new : current_user_session )
    @news = News.find( :all, :conditions => [ 'map_layers.map_id = ?', @default_map.id ], :include => [ :map_layer => :map ], :order => "news.created_at desc", :limit => 6 )
    @events = Event.find( :all, :conditions => [ 'map_layers.map_id = ?', @default_map.id ], :include => [ :map_layer => :map ], :order => "events.created_at desc", :limit => 6 )
    @networks = Network.find( :all, :conditions => [ 'map_layers.map_id = ?', @default_map.id ], :include => [ :map_layer => :map ], :order => "networks.created_at desc", :limit => 6 )
    @stuffs = Stuff.find( :all, :conditions => [ 'map_layers.map_id = ?', @default_map.id ], :include => [ :map_layer => :map ], :order => "stuffs.created_at desc", :limit => 6 )
    @fix_its = FixIt.find( :all, :conditions => [ 'map_layers.map_id = ?', @default_map.id ], :include => [ :map_layer => :map ], :order => "fix_its.created_at desc", :limit => 6 )
  end
  
  def universal_add_content
    
    @default_map = Map.find_by_shortname( "lightrail", :include => [ :interest_points ] )
    
    render :update do | page |
      page.replace_html "postuniversalcontent", :partial => "citycircles/post_universal_content", :locals => { :default_map => @default_map }
      page << "$j( '#postuniversalcontent' ).dialog( 'open' );$j( '#postuniversalcontent' ).dialog( 'option', 'position', [ 'center', 'center' ] );$( 'content_type' ).options[ #{ params[ :content_type_index ] } ].selected = true;"
    end
    
  end
  
end
