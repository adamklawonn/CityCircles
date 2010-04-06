Given /^there is a user with the email "([^\"]*)"$/ do |email|
  u = Factory.create(:user, {:email => email})
  ud = Factory.create(:user_detail, {:user_id => u.id})
end

Given /^there is a map called "([^\"]*)" with "([^\"]*)" layers created by "([^\"]*)"$/ do |map_title, layers, author|
  u = User.find_by_email(author)
  m = Factory.create(:map,  {:title => map_title, :author_id => u.id})
  
  layers.each_with_index do |layer, i|
    Factory.create(:map_layer, {:title => "Layer Title #{i}", :shortname => "Short Name #{i}", :map_id => m.id, :author_id => u.id})
  end
end

Given /^there is a map called "([^\"]*)" with a layer called "([^\"]*)" created by "([^\"]*)"$/ do |map_title, layer, author|
  u = User.find_by_email(author)
  m = Factory.create(:map,  {:title => map_title, :author_id => u.id})
  Factory.create(:map_layer, {:title => layer, :shortname => layer, :map_id => m.id, :author_id => u.id})
end

Given /^there is a collection of map icons created by "([^\"]*)"$/ do |author|
  u = User.find_by_email(author)
  Factory.create(:map_icon, {:author_id => u.id})
  Factory.create(:map_icon, {:shortname => "interestpoint", :image_url => "/images/map_icons/stopcon.png", :icon_size => "20, 20", :author_id => u.id})
  Factory.create(:map_icon, {:shortname => "news", :image_url => "/images/map_icons/newsimage.png", :icon_size => "20, 20", :author_id => u.id})
  Factory.create(:map_icon, {:shortname => "events", :image_url => "/images/map_icons/eventsimage.png", :icon_size => "20, 20", :author_id => u.id})
  Factory.create(:map_icon, {:shortname => "network", :image_url => "/images/map_icons/networkimage.png", :icon_size => "20, 20", :author_id => u.id})
  Factory.create(:map_icon, {:shortname => "promos", :image_url => "/images/map_icons/promosimage.png", :icon_size => "20, 20", :author_id => u.id})
  Factory.create(:map_icon, {:shortname => "stuff", :image_url => "/images/map_icons/stuffimage.png", :icon_size => "20, 20", :author_id => u.id})
  Factory.create(:map_icon, {:shortname => "fixit", :image_url => "/images/map_icons/fixitimage.png", :icon_size => "20, 20", :author_id => u.id})
end

Given /^there is a "([^\"]*)" post type on "([^\"]*)" with a "([^\"]*)" icon$/ do |post_type, map_layer, map_icon|
  ml = MapLayer.find_by_title(map_layer)
  mi = MapIcon.find_by_shortname(map_icon)
  Factory.create(:post_type, {:name => post_type, :shortname => post_type.downcase,:map_layer_id => ml.id, :map_icon_id => mi.id})
end

Given /^there is a point of interest called "([^\"]*)" on "([^\"]*)" map at "([^\"]*)" layer with "([^\"]*)" icon created by "([^\"]*)"$/ do |poi, map_title, map_layer, map_icon, author|
  u = User.find_by_email(author)
  m = Map.find_by_title(map_title)
  ml = MapLayer.find_by_title(map_layer)
  mi = MapIcon.find_by_shortname(map_icon)
  Factory.create(:interest_point,{:label => poi, :map_id => m.id, :map_layer_id => ml.id, :map_icon_id => mi.id, :author_id => u.id})
end

Given /^there is a post called "([^\"]*)" of type "([^\"]*)" for point of interest "([^\"]*)" created by "([^\"]*)"$/ do |post_headline, post_type, poi_label, author|
  u = User.find_by_email(author)
  poi = InterestPoint.find_by_label(poi_label)
  pt = PostType.find_by_name(post_type)
  event_item = Post.new(:headline => post_headline, 
                        :short_headline => "#{post_headline} shortname", 
                        :body => "Body", 
                        :author_id => u.id, 
                        :lat => poi.lat, 
                        :lng => poi.lng, 
                        :interest_point_id => poi.id, 
                        :map_layer_id =>poi.map_layer_id, 
                        :post_type_id => pt.id )
  event_item.event = Event.new( :starts_at => Time.now, :ends_at => Time.now )
  event_item.save!
  #e = Factory.create(:event, {:starts_at => Time.now, :ends_at => Time.now})
  #Factory.create(:post, {:headline => post_headline, :author_id => u.id, :lat => poi.lat, :lng => poi.lng, :interest_point_id => poi.id, :map_layer_id => poi.map_layer_id ,:post_type_id => pt.id, :event_id => e.id})
end

Given /^I have an interest point$/ do
  interest_point = Factory.create(:interest_point)
end

Given /^I have an organization with name "([^\"]*)" with author "([^\"]*)"$/ do |org, author|
  u = User.find_by_email(author)
  poi = InterestPoint.first
  Factory.create(:organization,{:name => org, :author_id => u.id, :interest_point_id => poi})
end

Given /^there is an event called "([^\"]*)" which starts on "([^\"]*)" and ends on "([^\"]*)"$/ do |name, start_date, end_date|
  Factory.create(:event,{:starts_at => start_date.to_date,
                         :ends_at => end_date.to_date,
                         :post => Factory.create(:event_post, {:headline => name, 
                                               :short_headline => name, 
                                               :body => "Body"})})
end

Given /^there is an event called "([^\"]*)" at location "([^\"]*)"$/ do |name, location|
  res = MultiGeocoder.geocode(location)
  Factory.create(:event,{:post => Factory.create(:event_post, {:headline => name, 
                                               :short_headline => name, 
                                               :body => "Body",
                                               :lat => res.lat,
                                               :lng => res.lng})})
end

Given /^there is an event called "([^\"]*)"$/ do |name|
  Factory.create(:event,{:post => Factory.create(:event_post, {:headline => name, 
                                               :short_headline => name, 
                                               :body => "Body"})})
end

Given /^there is an news post called "([^\"]*)"$/ do |name|
  Factory.create(:event,{:post => Factory.create(:news_post, {:headline => name, 
                                               :short_headline => name, 
                                               :body => "Body",
                                               :post_type => Factory.create(:post_type, {:name => "News"})})})
end

Given /^I have setup (my|the) homepage$/ do |arg|
  Given 'there is a user with the email "steve.swedler@integrumtech.com"'
  Given 'there is a map called "Map 1" with "3" layers created by "steve.swedler@integrumtech.com"'
  Given 'there is a collection of map icons created by "steve.swedler@integrumtech.com"'
  Given 'there is a "Events" post type on "Layer Title 0" with a "news" icon'
  Given 'there is a point of interest called "Interesting Point" on "Map 1" map at "Layer Title 0" layer with "news" icon created by "steve.swedler@integrumtech.com"'
  Given 'there is a post called "My Post" of type "Events" for point of interest "Interesting Point" created by "steve.swedler@integrumtech.com"'
  Factory.create(:post_type, {:name => "News"})
end

Given /^I am logged in as "([^\"]*)" with password "([^\"]*)"$/ do |username, password|
  visit "/signin"
  fill_in "user_session_login", :with => username
  fill_in "user_session_password", :with => password
  click_button "Login"
end

Then /^I should wait for the page to load/ do 
  sleep(10.0)
end

When /^I visit "([^\"]*)"$/ do |url|
  visit url
end

Given /^the following interests:$/ do |table|
  table.hashes.each do |attributes|
    Factory.create(:interest, attributes)
  end
end

Given /^the following hobbies:$/ do |table|
  table.hashes.each do |attributes|
    Factory.create(:hobby, attributes)
  end
end

Given /^the following interest points:$/ do |table|
  table.hashes.each do |attributes|
    Factory.create(:interest_point, attributes)
  end
end

Given /^I have the interest "([^\"]*)"$/ do |interest_name|
  Factory.create(:user_interest, :interest_id => Interest.find_by_name(interest_name).id, :user_id => User.first.id)
end

Given /^I have the hobby "([^\"]*)"$/ do |hobby_name|
  Factory.create(:user_hobby, :hobby_id => Hobby.find_by_name(hobby_name).id, :user_id => User.first.id)
end

Given /^I have the location "([^\"]*)"$/ do |interest_point_label|
  Factory.create(:user_location, :interest_point_id => InterestPoint.find_by_label(interest_point_label).id, :user_id => User.first.id)
end

Then /^"([^\"]*)" should be checked$/ do |label|
  assert ['checked', true].include?(find_field(label)['checked'])
end