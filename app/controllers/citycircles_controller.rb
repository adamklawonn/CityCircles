class CitycirclesController < ApplicationController
  
  skip_before_filter :browser_detect, :only => :incompatible_browser
  
  def index
    @default_map = Map.find_by_shortname( "lightrail", :include => [ :map_layers ] )
    @user_session = ( current_user_session.nil? ? UserSession.new : current_user_session )
    @news = Post.find( :all, :conditions => [ 'post_type_id = ? and map_layers.map_id = ? and ( posts.created_at >= ? and posts.created_at <= ? ) and is_draft = ?', PostType.find_by_shortname('news'), @default_map.id, 14.days.ago, 14.days.from_now, false ], :include => [ :map_layer => :map ], :order => "posts.sticky desc, posts.created_at desc", :limit => 8 )
    logger.info("GETTING EVENTS")
    @events = Post.find( :all, :conditions => [ 'post_type_id = ? and map_layers.map_id = ? and ( posts.created_at >= ? and posts.created_at <= ? ) and is_draft = ?', PostType.find_by_shortname('events'), @default_map.id, 14.days.ago, 14.days.from_now, false ], :include => [ :map_layer => :map ], :order => "posts.sticky desc, posts.created_at desc", :limit => 8 )
    logger.info("AFTER EVENTS")
    @networks = Post.find( :all, :conditions => [ 'post_type_id = ? and map_layers.map_id = ? and ( posts.created_at >= ? and posts.created_at <= ? ) and is_draft = ?', PostType.find_by_shortname('network'), @default_map.id, 14.days.ago, 14.days.from_now, false ], :include => [ :map_layer => :map ], :order => "posts.sticky desc, posts.created_at desc", :limit => 8 )
    @stuffs = Post.find( :all, :conditions => [ 'post_type_id = ? and map_layers.map_id = ? and ( posts.created_at >= ? and posts.created_at <= ? ) and is_draft = ?', PostType.find_by_shortname('stuff'), @default_map.id, 14.days.ago, 14.days.from_now, false ], :include => [ :map_layer => :map ], :order => "posts.sticky desc, posts.created_at desc", :limit => 8 )
    @fix_its = Post.find( :all, :conditions => [ 'post_type_id = ? and map_layers.map_id = ? and ( posts.created_at >= ? and posts.created_at <= ? ) and is_draft = ?', PostType.find_by_shortname('fixit'), @default_map.id, 14.days.ago, 14.days.from_now, false ], :include => [ :map_layer => :map ], :order => "posts.sticky desc, posts.created_at desc", :limit => 8 )
    
    # ads
    #@under_map_ad = Ad.find( :first, :conditions => [ 'placement = ? and is_approved = ? and ( ? between starts_at and ends_at )', 'Homepage Under Map', true, Time.now ] , :order => "RAND()")
    #@map_ads = Ad.find( :all, :conditions => [ 'placement = ? and is_approved = ? and ( ? between starts_at and ends_at )', 'Homepage Map', true, Time.now ], :order => "weight asc", :limit => 2 )
    @under_map_ad = Ad.find :first, :conditions => ['placement = ? and is_approved = ? and (starts_at >= ? and ends_at <= ?)', 'Homepage Under Map', true, Time.now.strftime('%Y/%m/%d %H:%M:%S'), Time.now.strftime('%Y/%m/%d %H:%M:%S')]
    @map_ads = Ad.find :all, :conditions => ['placement = ? and is_approved = ? and (starts_at >= ? and ends_at <= ?)', 'Homepage Map', true, Time.now.strftime('%Y/%m/%d %H:%M:%S'), Time.now.strftime('%Y/%m/%d %H:%M:%S')]
  end
  
  def universal_add_content
    
    @default_map = Map.find_by_shortname( "lightrail", :include => [ :interest_points ] )
    @post_universal_content_options = [ [ "News", "news" ], [ "Event", "events" ], [ "Network", "network" ], [ "Stuff", "stuff" ], [ "Fix It", "fixit" ] ] 
    render :update do | page |
      page.replace_html "postuniversalcontent", :partial => "citycircles/post_universal_content", :locals => { :default_map => @default_map }
      page << "$j( '#postuniversalcontent' ).dialog( 'open' );$j( '#postuniversalcontent' ).dialog( 'option', 'position', [ 'center', 'center' ] );$( 'pt' ).options[ #{ params[ :content_type_index ] } ].selected = true;"
    end
    
  end
  
  def incompatible_browser
    render
  end
  
end
