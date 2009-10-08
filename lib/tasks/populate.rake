require 'csv'
require 'rubygems'
require 'random_data'

namespace :db do
  
  desc "Populate database with test data."
  task :populate => [ :environment, :drop, :create, :migrate ] do
    
    # Create default user.
    user = User.new( :login => 'citycircles', :email => 'caigesn@gmail.com', :password => 'dailyphx', :password_confirmation => 'dailyphx' )
    user.user_detail = UserDetail.new
    user.save!
    
    user_caige = User.new( :login => 'caiges', :email => 'caige@sevenblend.com', :password => 'railsphx', :password_confirmation => 'railsphx' )
    user_caige.user_detail = UserDetail.new
    user_caige.save!
    user_caige.add_role "admin"
    user_caige.save!
    
    user_adam = User.new( :login => 'adamk', :email => 'adam.klawonn@gmail.com', :password => 'railsphx', :password_confirmation => 'railsphx' )
    user_adam.user_detail = UserDetail.new
    user_adam.save!
    user_adam.add_role "admin"
    user_adam.save!
    
    user_aleks = User.new( :login => 'aleksc', :email => 'Aleksandrra@gmail.com', :password => 'railsphx', :password_confirmation => 'railsphx' )
    user_aleks.user_detail = UserDetail.new
    user_aleks.save!
    user_aleks.add_role "admin"
    user_aleks.save!
    
    user_scott = User.new( :login => 'scotts', :email => 'squiglie@gmail.com', :password => 'railsphx', :password_confirmation => 'railsphx' )
    user_scott.user_detail = UserDetail.new
    user_scott.save!
    user_scott.add_role "admin"
    user_scott.save!
    
    # Create default map, layers, and interest points.
    map = Map.new( :title => "Light Rail", :description => "METRO Light Rail is a 20-mile (32 km) light rail line operating in the cities of Phoenix, Tempe, and Mesa, Arizona and is part of the Valley Metro public transit system. Construction began in March 2005; operation started December 27, 2008.", :shortname => "lightrail", :lat => 33.474644, :lng => -111.98665, :zoom => 11 )
    map.author = user
    map.save!
    # Create map layers.
    light_rail_layer = MapLayer.new( :title => "Light Rail", :shortname => "lightrailline" )
    light_rail_layer.author = user
    light_rail_layer.map = map
    light_rail_layer.save!
    news_layer = MapLayer.new( :title => "News", :shortname => "news" )
    news_layer.author = user
    news_layer.map = map
    news_layer.save!
    events_layer = MapLayer.new( :title => "Events", :shortname => "events" )
    events_layer.author = user
    events_layer.map = map
    events_layer.save!
    network_layer = MapLayer.new( :title => "Network", :shortname => "network" )
    network_layer.author = user
    network_layer.map = map
    network_layer.save!
    promos_layer = MapLayer.new( :title => "Promos", :shortname => "promos" )
    promos_layer.author = user
    promos_layer.map = map
    promos_layer.save!
    stuff_layer = MapLayer.new( :title => "Stuff", :shortname => "stuff" )
    stuff_layer.author = user
    stuff_layer.map = map
    stuff_layer.save!
    # Create interest point icon.
    poi_icon = MapIcon.new :shortname => "default", :image_url => "http://maps.gstatic.com/intl/en_us/mapfiles/markerTransparent.png", :icon_size => "20, 20", :author_id => user.id
    poi_icon.save!
    poi_stop_icon = MapIcon.new :shortname => "interestpoint", :image_url => "/images/map_icons/stopcon.png", :icon_size => "20, 20", :author_id => user.id
    poi_stop_icon.save!
    news_icon = MapIcon.new :shortname => "news", :image_url => "/images/map_icons/news/newsimage.png", :shadow_url => "/images/map_icons/news/newsshadow.png", :icon_size => "43, 30", :shadow_size => "43, 30", :icon_anchor => "15, 30", :info_window_anchor => "15, 0", :author_id => user.id
    news_icon.save!
    events_icon = MapIcon.new :shortname => "events", :image_url => "/images/map_icons/events/eventsimage.png", :shadow_url => "/images/map_icons/events/eventsshadow.png", :icon_size => "43, 30", :shadow_size => "43, 30", :icon_anchor => "15, 30", :info_window_anchor => "15, 0", :author_id => user.id
    events_icon.save!
    network_icon = MapIcon.new :shortname => "network", :image_url => "/images/map_icons/network/networkimage.png", :shadow_url => "/images/map_icons/network/networkshadow.png", :icon_size => "43, 30", :shadow_size => "43, 30", :icon_anchor => "15, 30", :info_window_anchor => "15, 0", :author_id => user.id
    network_icon.save!
    promos_icon = MapIcon.new :shortname => "promos", :image_url => "/images/map_icons/promos/promosimage.png", :shadow_url => "/images/map_icons/promos/promosshadow.png", :icon_size => "43, 30", :shadow_size => "43, 30", :icon_anchor => "15, 30", :info_window_anchor => "15, 0", :author_id => user.id
    promos_icon.save!
    stuff_icon = MapIcon.new :shortname => "stuff", :image_url => "/images/map_icons/stuff/stuffimage.png", :shadow_url => "/images/map_icons/stuff/stuffshadow.png", :icon_size => "43, 30", :shadow_size => "43, 30", :icon_anchor => "15, 30", :info_window_anchor => "15, 0", :author_id => user.id
    stuff_icon.save!
    # Create interest points.
    CSV.foreach( File.join File.dirname( __FILE__ ), "assets/valley_metro_light_rail.csv" ) do |row|
      poi = InterestPoint.new( :label => row[ 2 ], :lat => row[ 1 ].to_f, :lng => row[ 0 ].to_f )
      poi.map_icon = poi_stop_icon
      poi.author = user
      poi.map = map
      poi.map_layer = light_rail_layer
      poi.save!
      poi.body = "<strong>#{ poi.label }</strong><br /><br /><a href='/places/#{ poi.id }'>Jump to this place</a>"
      poi.save!
      
      # Generate suedo random news items.
      titles = [ "Homeless population skyrockets as economy sinks", "Budget cuts impact iconic Phoenix park", "Filmmaker's rise shows Phoenix's movie-industry potential", "Never too late to remember", "One bullish Matador", "For black artists, a new home is a work in progress", "That’s ‘Mrs. Green’ to you" ]
      
      if rand( 2 ) == 1
        title = titles[ rand( titles.length ) ]
        north = 1
        while north > 0.3 and north != 0
          north = rand
        end
        east = 1
        while east > 0.3 and east != 0
          east = rand
        end
        north_east = [ north, east ]
        latlng = poi.endpoint( [ 0, 90 ][ rand( 2 ) ], north_east[ rand( 2 ) ] )
        news_item = News.new( :headline => title, :body => Random.paragraphs( 4 ), :author_id => user.id, :lat => latlng.lat, :lng => latlng.lng, :interest_point_id => poi.id, :map_layer_id => news_layer.id, :map_icon_id => news_icon.id )
        news_item.save!
      end
      
    end
    # Create interest lines.
    CSV.foreach( File.join File.dirname( __FILE__ ), "assets/valley_metro_light_rail_line.csv" ) do |row|
      poi = InterestLine.new( :label => "Valley Metro Light Rail Line", :shortname => "VMLRL", :lat => row[ 1 ].to_f, :lng => row[ 0 ].to_f )
      poi.author = user
      poi.map = map
      poi.map_layer = light_rail_layer
      poi.save!
    end
    CSV.foreach( File.join File.dirname( __FILE__ ), "assets/valley_metro_light_rail_line_north_route_downtown.csv" ) do |row|
      poi = InterestLine.new( :label => "Valley Metro Light Rail Line (North Route Downtown)", :shortname => "VMLRLNRD", :lat => row[ 1 ].to_f, :lng => row[ 0 ].to_f )
      poi.author = user
      poi.map = map
      poi.map_layer = light_rail_layer
      poi.save!
    end
    
    # Create wireless profiles.
    att = WirelessCarrier.new( :name => "AT&T", :email_gateway => "txt.att.net" )
    att.save!
    
    sprint = WirelessCarrier.new( :name => "Sprint", :email_gateway => "messaging.sprintpcs.com" )
    sprint.save!
    
    # Create default pages.
    about_page = Page.new( :title => "About", :shortname => "about", :description => "The about page.", :body => "This is the about page", :author_id => user.id, :show_in_navigation => true, :sort => 1 )
    about_page.save!
    advertise_page = Page.new( :title => "Advertise", :shortname => "advertise", :description => "The advertise page.", :body => "This is the advertise page", :author_id => user.id, :show_in_navigation => true, :sort => 2 )
    advertise_page.save!
    contact_page = Page.new( :title => "Contact", :shortname => "contact", :description => "The contact page.", :body => "This is the contact page", :author_id => user.id, :show_in_navigation => true, :sort => 3 )
    contact_page.save!
  end
  
end