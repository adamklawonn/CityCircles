class UserDetailsController < ApplicationController
  
  def edit
    @user = User.find( params[ :id ], :include => [ :user_detail ] )
  end
  
  def update
    @user_detail = UserDetail.find_or_create( params[ :account_id ] )
    if @user_detail.update_attributes params[ :user_detail ]
      flash[ :notice ] = "Profile updated!"
      redirect_to account_profile @user_detail
    else
      render :action => :edit
    end
  end
  
  def show
    @user_detail = UserDetail.find_or_create( params[ :account_id ] )
  end
  
end
