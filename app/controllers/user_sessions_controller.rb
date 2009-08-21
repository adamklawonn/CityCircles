class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
    render 'new'
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      respond_to do | format |
        format.js do
          render :update do | page |
            page.redirect_to root_url
          end
        end
      end
    else
      respond_to do | format |
        format.js { render :create, :layout => false }
      end
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    #redirect_back_or_default new_user_session_url
    redirect_to root_url
  end
end