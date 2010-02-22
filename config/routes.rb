ActionController::Routing::Routes.draw do |map|
  map.search "/search/:q", :controller => :posts, :action => :search, :q => nil
  map.resources :cached_blogroll_feeds
  map.resources :email_blast_templates
  map.resources :organization_members
  map.resources :post_attachments
  map.resources :ads
  map.resources :tweets
  map.resources :post_types
  map.resources :posts, :member => { :news => :get, :events => :get, :promos => :get, :networks => :get, :stuff => :get, :fixit => :get }, :collection => { :all_news => :get, :all_events => :get, :all_promos => :get, :all_networks => :get, :all_stuff => :get, :all_fixit => :get }
  map.resources :user_hobbies
  map.resources :user_interests
  map.resources :hobbies
  map.resources :interests
  map.signin "/signin", :controller => "user_sessions", :action => "new"
  map.signout "/signout", :controller => "user_sessions", :action => "destroy"
  map.signup "/signup", :controller => "users", :action => "new"
  map.sendverification "/sendverification", :controller => "users", :action => "sendverification"
  map.verify "/verify/:satoken", :controller => "users", :action => "verify"
  map.settings "/settings", :controller => "user_settings", :action => "index"
  map.profile "/profile", :controller => "users", :action => "show"
  map.page_by_shortname "/pages/:shortname", :controller => "pages", :action => "show"
  map.resources :suggestions  #map.resources :stuffs  map.resources :file_attachments
  map.resources :user_locations
  map.resources :interest_point_icons
  map.resources :interest_lines
  map.resources :site_options
  map.resources :pages
  map.resources :organizations
  map.resources :wireless_carriers
  map.resources :register, :controller => "users"
  map.resources :user_wireless_profiles
  map.resources :user_details
  map.resources :comments  
  map.resources :promos
  map.resources :map_layers, :has_many => [ :interest_points ]
  map.resources :maps, :collection => { :next => :get }, :has_many => [ :map_layers, :interest_points, :interest_lines ]
  map.resources :interest_points, :as => "places", :member => { :news => :get, :events => :get, :promos => :get, :networks => :get, :stuff => :get, :fixit => :get }, :collection => { :news => :get, :events => :get, :promos => :get, :networks => :get, :stuff => :get, :fixit => :get }, :has_many => :posts
  map.resources :events
  map.resources :news, :collection => { :poi => :get }, :has_many => [ :comments ]
  map.resource :user_session
  map.resources :accounts, :controller => "users" do | accounts |
    accounts.resources :profile, :controller => "user_details"
  end
  map.resource :user
  map.root :controller => "citycircles", :action => "index" # optional, this just sets the root route
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
