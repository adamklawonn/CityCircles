require 'csv'

namespace :db do
  
  desc "Populate database with test data."
  task :populate => [ :environment, :drop, :create, :migrate ] do
    
    # Create default user.
    user = User.new( :login => 'citycircles', :email => 'caigesn@gmail.com', :password => 'dailyphx', :password_confirmation => 'dailyphx' )
    user.user_profile = UserProfile.new
    user.save!
    user.add_role "admin"
    user.save!
    
    user_caige = User.new( :login => 'caiges', :email => 'caige@sevenblend.com', :password => 'railsphx', :password_confirmation => 'railsphx' )
    user_caige.user_profile = UserProfile.new
    user_caige.save!
    user_caige.add_role "admin"
    user_caige.save!
    
    user_adam = User.new( :login => 'adamk', :email => 'adam.klawonn@gmail.com', :password => 'railsphx', :password_confirmation => 'railsphx' )
    user_adam.user_profile = UserProfile.new
    user_adam.save!
    user_adam.add_role "admin"
    user_adam.save!
    
    user_aleks = User.new( :login => 'aleksc', :email => 'Aleksandrra@gmail.com', :password => 'railsphx', :password_confirmation => 'railsphx' )
    user_aleks.user_profile = UserProfile.new
    user_aleks.save!
    user_aleks.add_role "admin"
    user_aleks.save!
    
    user_scott = User.new( :login => 'scotts', :email => 'squiglie@gmail.com', :password => 'railsphx', :password_confirmation => 'railsphx' )
    user_scott.user_profile = UserProfile.new
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
    # Create interest point icon.
    poi_icon = InterestPointIcon.new :image_url => "http://maps.gstatic.com/intl/en_us/mapfiles/markerTransparent.png", :author_id => user.id
    poi_icon.save!
    poi_stop_icon = InterestPointIcon.new :image_url => "/images/map_icons/stopcon.png", :author_id => user.id
    poi_stop_icon.save!
    # Create interest points.
    CSV.foreach( File.join File.dirname( __FILE__ ), "assets/valley_metro_light_rail.csv" ) do |row|
      poi = InterestPoint.new( :label => row[ 2 ], :lat => row[ 1 ].to_f, :lng => row[ 0 ].to_f )
      poi.interest_point_icon = poi_stop_icon
      poi.author = user
      poi.map = map
      poi.map_layer = light_rail_layer
      poi.save!
      poi.body = "<strong>#{ poi.label }</strong><br /><br /><a href='/places/#{ poi.id }'>Jump to this place</a>"
      poi.save!
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