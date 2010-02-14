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
      UserMailer.deliver_registration(@user)
      render :action => :sendverification
    else
      render :action => :new
    end
  end
  
  def show
    @ad = Ad.find( :first, :conditions => [ 'placement = ? and ( ? between starts_at and ends_at )', 'Profile', Time.now ] )
    @default_map = Map.find_by_shortname( "lightrail", :include => [ :map_layers ] )
    @user = User.find( current_user.id, :include => [ :user_detail, :user_locations, :user_wireless_profiles ] )
    @user_hobbies_interests = ( ( @user.user_interests.collect { | i | i.interest.name } + @user.user_hobbies.collect { | i | i.hobby.name } ).sort { rand } ).join( ", " )
    @ad = Ad.find( :first, :conditions => [ 'placement = ? and ( ? between starts_at and ends_at ) and interest_point_id in ( ? )', 'Profile', Time.now, ( @user.user_locations.collect { | i | i.interest_point_id } ).join( ", " ) ] )
    @map_ads = Ad.find( :all, :conditions => [ 'placement = ? and is_approved = ? and ( ? between starts_at and ends_at )', 'Profile Map', true, Time.now ], :order => "weight asc", :limit => 2 )

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
  
  def sendverification
    @user = User.find_by_email params[ :email ]
    UserMailer.deliver_registration(@user)
  end
  
  def verify
    @user = User.find_by_single_access_token params[ :satoken ]
    if @user != nil
      if !@user.email_verified 
        if @user.update_attribute(:email_verified, true)
          flash[:notice] = "Account verified!"
          UserMailer.deliver_welcome(@user)
          redirect_to profile_url
        else
          flash[:notice] = "Account could not be verified!"
          render :action => :sendverification
        end
      else
        flash[:notice] = "Account has already been verified!"
        render :action => :sendverification
      end
    else  
      flash[:notice] = "Account could not be verified!"
      render :action => :sendverification
    end
  end
  
end
