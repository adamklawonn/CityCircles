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
