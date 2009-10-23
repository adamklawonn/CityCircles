ActionController::Routing::Routes.draw do |map|
  map.signin "/signin", :controller => "user_sessions", :action => "new"
  map.signout "/signout", :controller => "user_sessions", :action => "destroy"
  map.signup "/signup", :controller => "users", :action => "new"
  map.settings "/settings", :controller => "user_settings", :action => "index"
  map.profile "/profile", :controller => "users", :action => "show"
  map.page_by_shortname "/pages/:shortname", :controller => "pages", :action => "show"
  map.resources :suggestions
  map.resources :fix_its
  map.resources :stuffs
  map.resources :networks
  map.resources :file_attachments
  map.resources :user_locations
  map.resources :interest_point_icons
  map.resources :interest_lines
  map.resources :site_options
  map.resources :pages
  map.resources :organizations
  map.resources :map_layers
  map.resources :wireless_carriers
  map.resources :register, :controller => "users"
  map.resources :user_wireless_profiles
  map.resources :user_details
  map.resources :comments
  map.resources :photos
  map.resources :promos
  map.resources :maps
  map.resources :interest_points, :as => "places", :has_many => [ :news, :events, :networks, :stuffs, :fix_its ]
  map.resources :events
  map.resources :news, :collection => { :poi => :get }
  map.resource :user_session
  map.resources :accounts, :controller => "users" do | accounts |
    accounts.resources :profile, :controller => "user_details"
  end
  map.resource :user
  map.namespace :admin do | admin |
    admin.root :controller => "admin", :action => "index"
    admin.resource :inbox, :controller => "inbox", :collection => { :index => :get }
    admin.resource :maps, :collection => { :index => :get }
    admin.resource :pages, :collection => { :index => :get }
    admin.resource :users, :collection => { :index => :get }
    admin.resource :networks, :collection => { :index => :get }
    admin.resources :stuffs, :collection => { :index => :get }
    admin.resources :fix_its, :collection => { :index => :get }
    admin.resources :suggestions, :collection => { :index => :get }
  end
  map.root :controller => "citycircles", :action => "index" # optional, this just sets the root route
    
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
