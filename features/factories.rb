Factory.define :wireless_carrier do |wc|
  wc.name 'Wireless Carrier Name'
  wc.email_gateway 'Wireless Email Gateway'
end

Factory.define :suggestion do |s|
  s.email 'test@user.com'
  s.body 'this is the suggestion body'
end

Factory.define :post_attachment do |pa|
  pa.post_id 0
  pa.caption 'attachment caption'
  pa.oembed 'o embed'
  pa.code 'attachment code'
end

Factory.define :promo do |p|
  p.title 'Promo Title'
  p.organization {|o| o.association(:organization)}
  p.post {|post| post.association(:post)}
  p.author {|a| a.association(:user)}
  p.starts_at Time.now
  p.ends_at Time.now + 1.day
  p.is_approved true
end

Factory.define :organization_member do |om|
  om.user_id 0
  om.organization_id 0
  om.active true
end

Factory.define :user_location do |ul|
  ul.user_id 0
  ul.interest_point_id 0
end

Factory.define :user_hobby do |ui|
  ui.user_id 0
  ui.hobby_id 0
end

Factory.define :hobby do |h|
  h.name 'Baseball'
end

Factory.define :user_interest do |ui|
  ui.user_id 0
  ui.interest_id 0
end

Factory.define :interest do |i|
  i.name 'Business'
end

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
  p.post_type {|pt| pt.association(:post_type)}
  p.interest_point {|ip| ip.association(:interest_point)}
  p.author {|a| a.association(:user)}
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
  ip.map {|m| m.association(:map)}
  ip.map_icon {|mi| mi.association(:map_icon)}
  ip.map_layer {|ml| ml.association(:map_layer)}
  ip.author {|a| a.association(:user)}
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
  u.roles ''
end

Factory.define :typus_user do |tu|
  tu.email 'admin@test.com'
  tu.role 'admin'
  tu.status '1'
  tu.password "columbia"
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
  org.interest_point {|ip| ip.association(:interest_point)}
  org.author {|a| a.association(:user)}
end

Factory.define :organization_member do |member|
  member.is_active "1"
end
  
Factory.define :interest do |interest|
  interest.name "Stuff"
end