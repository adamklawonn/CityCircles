class CitycirclesController < ApplicationController
  
  def index
    @user_session = ( current_user_session.nil? ? UserSession.new : current_user_session )
    @default_map = Map.find_by_shortname( "lightrail" )
    @map = Map.generate_gmap( @default_map )
  end
  
end
