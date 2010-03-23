Given /^I have a post with the following attributes:$/ do |table|
  pt = Factory.create(:post_type)
  map = Map.find_by_shortname( "lightrail")
  table.hashes.each do |attributes|
    Post.create!(attributes.merge({:post_type_id => pt.id}))
  end
end

Given /^I have a map with the following attributes:$/ do |table|
  table.hashes.each do |attributes|
    Map.create!(attributes)
  end
end

Given /^there is an author$/ do
  User.create( :login => 'citycircles', :email => 'caigesn@gmail.com', :password => 'dailyphx', :password_confirmation => 'dailyphx' )
end

Given /^there is a map$/ do
  Map.create( :title => "Stations", :description => "METRO Light Rail is a 20-mile (32 km) light rail line operating in the cities of Phoenix, Tempe, and Mesa, Arizona and is part of the Valley Metro public transit system. Construction began in March 2005; operation started December 27, 2008.", :shortname => "lightrail", :lat => 33.474644, :lng => -111.98665, :zoom => 11, :author_id => User.first.id )
end

Given /^there is a map icon$/ do
  MapIcon.create(:shortname => "default", :image_url => "http://maps.gstatic.com/intl/en_us/mapfiles/markerTransparent.png", :icon_size => "20, 20", :author_id => User.first.id)
end

Given /^there is an events map layer$/ do
  MapLayer.create( :title => "Events", :shortname => "events", :author_id => User.first.id, :map_id => Map.first.id )
end

Given /^there is an interest point$/ do
  InterestPoint.create( :label => 'Montebello / 19th Ave', :lat => 33.519894, :lng => -112.099709, :twitter_hashtag => '19mon', :map_layer_id => MapLayer.first.id, :author_id => User.first.id, :map_id => Map.first.id, :map_icon_id => MapIcon.first.id )
end

Given /^there is an event post type$/ do
  PostType.create( :name => "Event", :map_layer_id => MapLayer.first.id, :map_icon_id => MapIcon.first.id, :map_fill_color => "#6677B6", :map_stroke_color => "#4C5A8B", :map_stroke_width => 2, :shortname => "events", :twitter_hashtag => "e" )
end

Given /^there is a post of type event$/ do
  Post.create( :headline => 'Test Headline', :short_headline => 'Short Headline', :body => 'Test Body', :author_id => User.first.id, :lat => 33.519894, :lng => -112.099709, :interest_point_id => InterestPoint.first.id, :map_layer_id => MapLayer.first.id, :post_type_id => PostType.first.id )
end