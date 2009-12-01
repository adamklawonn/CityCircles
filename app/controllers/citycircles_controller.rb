class CitycirclesController < ApplicationController
  
  def index
    @default_map = Map.find_by_shortname( "lightrail", :include => [ :map_layers ] )
    @user_session = ( current_user_session.nil? ? UserSession.new : current_user_session )
    @news = Post.find( :all, :conditions => [ 'post_type_id = ? and map_layers.map_id = ?', 1, @default_map.id ], :include => [ :map_layer => :map ], :order => "posts.created_at desc", :limit => 8 )
    @events = Post.find( :all, :conditions => [ 'post_type_id = ? and map_layers.map_id = ?', 2, @default_map.id ], :include => [ :map_layer => :map ], :order => "posts.created_at desc", :limit => 8 )
    @networks = Post.find( :all, :conditions => [ 'post_type_id = ? and map_layers.map_id = ?', 3, @default_map.id ], :include => [ :map_layer => :map ], :order => "posts.created_at desc", :limit => 8 )
    @stuffs = Post.find( :all, :conditions => [ 'post_type_id = ? and map_layers.map_id = ?', 5, @default_map.id ], :include => [ :map_layer => :map ], :order => "posts.created_at desc", :limit => 8 )
    @fix_its = Post.find( :all, :conditions => [ 'post_type_id = ? and map_layers.map_id = ?', 6, @default_map.id ], :include => [ :map_layer => :map ], :order => "posts.created_at desc", :limit => 8 )
  end
  
  def universal_add_content
    
    @default_map = Map.find_by_shortname( "lightrail", :include => [ :interest_points ] )
    
    render :update do | page |
      page.replace_html "postuniversalcontent", :partial => "citycircles/post_universal_content", :locals => { :default_map => @default_map }
      page << "$j( '#postuniversalcontent' ).dialog( 'open' );$j( '#postuniversalcontent' ).dialog( 'option', 'position', [ 'center', 'center' ] );$( 'content_type' ).options[ #{ params[ :content_type_index ] } ].selected = true;"
    end
    
  end
  
end
