class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  #ssl_required :edit, :update
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    @user.user_detail = UserDetail.new
    if verify_recaptcha( :model => @user, :message => "Captcha response was incorrect!" ) && @user.save
      flash[:notice] = "Account registered!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def show
    @user = User.find( current_user.id, :include => [ :news, :events, :user_locations, :user_wireless_profiles ] )
  end
 
  def edit
    @user = @current_user
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end

end