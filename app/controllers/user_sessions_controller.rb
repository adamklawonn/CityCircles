class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [ :new, :create ]
  before_filter :require_user, :only => :destroy
  #ssl_required :new, :create
  
  def new
    @user_session = UserSession.new
    render 'new'
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      respond_to do | format |
        format.html { redirect_back_or_default root_url }
      end
    else
      respond_to do | format |
        format.html { render :new }
      end
    end
  end
  
  def destroy
    logger.info( current_user_session )
    @user_session = UserSession.find
    @user_session.destroy
    #flash[:notice] = "Logout successful!"
    clear_facebook_session_information
    redirect_to root_url
  end
end