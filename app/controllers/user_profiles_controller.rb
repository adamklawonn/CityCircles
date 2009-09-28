class UserProfilesController < ApplicationController
  
  def edit
    @user = User.find( params[ :id ], :include => [ :user_profile ] )
  end
  
  def update
    @user_profile = UserProfile.find_or_create( params[ :account_id ] )
    if @user_profile.update_attributes params[ :user_profile ]
      flash[ :notice ] = "Profile updated!"
      redirect_to account_profile @user_profile
    else
      render :action => :edit
    end
  end
  
  def show
    @user_profile = UserProfile.find_or_create( params[ :account_id ] )
  end
  
end
