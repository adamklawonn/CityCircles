Factory.define :post_type do |pt|
  pt.name 'Events'
  pt.shortname 'events'
  pt.map_fill_color "#F8AE5B"
  pt.map_stroke_color "#B78144"
  pt.map_stroke_width 2
  pt.twitter_hashtag "n"
  pt.map_icon {|mi| mi.association(:map_icon)}
  pt.map_layer {|ml| ml.association(:map_layer)}
end

Factory.define :post do |p|
  p.headline "headline"
  p.short_headline "short headline"
  p.body "Body"
  p.lat "33.519894"
  p.lng "-112.099709"
  p.map_layer {|ml| ml.association(:map_layer)}
end

Factory.define :event_post, :class => Post do |p|
  p.headline "headline"
  p.short_headline "short headline"
  p.body "Body"
  p.lat "33.519894"
  p.lng "-112.099709"
  p.post_type {|pt| pt.association(:post_type)}
  p.author {|a| a.association(:user)}
  p.interest_point {|ip| ip.association(:interest_point)}
  p.map_layer {|ml| ml.association(:map_layer)}
end

Factory.define :news_post, :class => Post do |p|
  p.headline "headline"
  p.short_headline "short headline"
  p.body "Body"
  p.lat "33.519894"
  p.lng "-112.099709"
  p.post_type {|pt| pt.association(:post_type)}
  p.author {|a| a.association(:user)}
  p.interest_point {|ip| ip.association(:interest_point)}
  p.map_layer {|ml| ml.association(:map_layer)}
end

Factory.define :interest_point do |ip|
  ip.map_id "1"
  ip.map_icon_id "2"
  ip.map_layer_id "3"
  ip.author_id "4"
  ip.label "Label"
  ip.lat "33.519894"
  ip.lng "-112.099709"
  ip.twitter_hashtag "hashme"
end

Factory.define :map do |m|
  m.shortname 'lightrail'
  m.title "Stations"
  m.description "METRO Light Rail is a 20-mile (32 km) light rail line operating in the cities of Phoenix, Tempe, and Mesa, Arizona and is part of the Valley Metro public transit system. Construction began in March 2005; operation started December 27, 2008."
  m.lat 33.474644
  m.lng -111.98665
  m.zoom 11
  m.author {|a| a.association(:user)}
end

Factory.define :user do |u|
  u.sequence(:email) {|n| "caigesn#{n}@gmail.com" }
  u.sequence(:login) {|n| "citycircles#{n}" }
  u.password 'dailyphx'
  u.password_confirmation 'dailyphx'
end

Factory.define :user_detail do |d|
  d.first_name  'City'
  d.last_name 'Circles'
end

Factory.define :map_layer do |l|
  l.title "Map Layer Title"
  l.shortname "Map Layer Title shortname"
  l.map {|m| m.association(:map)}
  l.author {|a| a.association(:user)}
end

Factory.define :map_icon do |mi|
  mi.shortname "default"
  mi.image_url "http://maps.gstatic.com/intl/en_us/mapfiles/markerTransparent.png"
  mi.icon_size "20, 20"
  mi.author {|a| a.association(:user)}
end

Factory.define :event do |e|
  e.starts_at Time.now
  e.ends_at Time.now
  e.post {|p| p.association(:event_post)}
end

Factory.define :organization do |org|
  org.name "Test Organization"
  org.lat "33.519894"
  org.lng "-112.099709"
end

Factory.define :organization_member do |member|
  member.is_active "1"
end
  
  