class ApplicationController < ActionController::Base
  # SSL
  include SslRequirement
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # Skip layout for xhr requests
  layout proc{ | c | c.request.xhr? ? false : "application" }
  
  before_filter :browser_detect
  before_filter :fetch_pages
  before_filter :new_suggestion
  before_filter :fetch_ads
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password 
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user
  
  private
  
    # No support for IE < 7
    def browser_detect
      case request.user_agent
        when /(gecko|opera|konqueror|khtml|webkit)/i
           # Do nothing.
        when /msie\s+6\.\d+/i
           redirect_to :controller => "citycircles", :action => "incompatible_browser"
        else
           redirect_to :controller => "citycircles", :action => "incompatible_browser"
      end
    end
    
    # Fetch pages for nav. 
    # This could be called asynchronously from js... 
    def fetch_pages
      @pages = Page.find( :all, :conditions => [ 'show_in_navigation = ?', true ] )
      #@pages = Page.connection.select_all( "select id, title, shortname from pages where show_in_navigation = 1 order by sort asc" )
    end
    
    # For the "everywhere" explore box
    def new_suggestion
      @suggestion = Suggestion.new
    end
    
    # Fetch ads for the map and soon other locations. This could be called asynchronously
    def fetch_ads
      @map_ads = Ad.find( :all, :conditions => [ 'placement = ? and ( ? between starts_at and ends_at )', 'Map', Time.now ], :order => "weight asc" )
    end
    
    # Fetch currently logged in user's session
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    # Feth currently logged in user
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
    
    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to do that!"
        redirect_to new_user_session_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to do that!"
        redirect_to account_url
        return false
      end
    end

    def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
    
    def ssl_required?

      # (Comment this one line out if you want to test ssl locally)
      return false if local_request? 

      # always return false for tests
      return false if RAILS_ENV == 'test'

      # otherwise, use the filters.
      super
    end

end
