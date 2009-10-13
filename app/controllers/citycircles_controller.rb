class CitycirclesController < ApplicationController
  
  def index
    @user_session = ( current_user_session.nil? ? UserSession.new : current_user_session )
    @default_map = Map.find_by_shortname( "lightrail" )
    @news = News.find( :all, :conditions => [ 'map_layers.map_id = ?', @default_map.id ], :include => [ :map_layer => :map ], :order => "news.created_at desc", :limit => 6 )
    @events = Event.find( :all, :conditions => [ 'map_layers.map_id = ?', @default_map.id ], :include => [ :map_layer => :map ], :order => "events.created_at desc", :limit => 6 )
    @networks = Network.find( :all, :conditions => [ 'map_layers.map_id = ?', @default_map.id ], :include => [ :map_layer => :map ], :order => "networks.created_at desc", :limit => 6 )
    @stuffs = Stuff.find( :all, :conditions => [ 'map_layers.map_id = ?', @default_map.id ], :include => [ :map_layer => :map ], :order => "stuffs.created_at desc", :limit => 6 )
    @fix_its = FixIt.find( :all, :conditions => [ 'map_layers.map_id = ?', @default_map.id ], :include => [ :map_layer => :map ], :order => "fix_its.created_at desc", :limit => 6 )
  end
  
end
