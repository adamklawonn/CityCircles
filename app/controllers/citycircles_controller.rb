class CitycirclesController < ApplicationController
  
  def index
    @user_session = ( current_user_session.nil? ? UserSession.new : current_user_session )
  end
  
end
