Factory.define :post_type do |pt|
  pt.name 'News'
  pt.shortname 'news'
  pt.map_fill_color "#F8AE5B"
  pt.map_stroke_color "#B78144"
  pt.map_stroke_width 2
  pt.twitter_hashtag "n"
end

Factory.define :post do |p|
  p.headline "headline"
  p.short_headline "short headline"
  p.body "Body"
  p.lat "33.519894"
  p.lng "-112.099709"
end

Factory.define :interest_point do |ip|
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
end

Factory.define :user do |u|
  u.login 'citycircles'
  u.email 'caigesn@gmail.com'
  u.password 'dailyphx'
  u.password_confirmation 'dailyphx'
end

Factory.define :user_detail do |d|
  d.first_name  'City'
  d.last_name 'Circles'
end

Factory.define :map_layer do |l|
  l.title ""
  l.shortname ""
end

Factory.define :map_icon do |mi|
  mi.shortname "default"
  mi.image_url "http://maps.gstatic.com/intl/en_us/mapfiles/markerTransparent.png"
  mi.icon_size "20, 20"
end

Factory.define :event do |e|
  e.starts_at Time.now
  e.ends_at Time.now
end
