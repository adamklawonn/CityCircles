class UserSettingsController < ApplicationController
  
  def index
    @user = User.find( current_user.id )
    @user_detail = @user.user_detail
    @user_wireless_profile = UserWirelessProfile.new
    @user_location = UserLocation.new
    @default_map = Map.find_by_shortname( "lightrail", :include => [ :map_layers, :interest_points ] )
  end
  
  def update_user
    @user = current_user
    if @user.update_attributes(params[:user])
      render :update do | page |
        page.replace_html "user_form", :partial => "account_settings"
        page.replace_html "notice", "Account settings updated."
        page.visual_effect :toggle_blind, 'notice'
        page.delay 3 do
          page.visual_effect :toggle_blind, 'notice'
        end
      end
    else
      render :update do | page |
        page.replace_html "user_form", :partial => "account_settings"
      end
    end
  end

  def update_user_detail
    user = current_user
    @user_detail = user.user_detail
    if @user_detail.update_attributes(params[:user_detail])
      respond_to do | format |
        format.js do
          responds_to_parent do
            render :update do | page |
              page.replace_html "user_detail_form", :partial => "profile"
              page.replace_html "notice", "Profile updated."
              page.visual_effect :toggle_blind, 'notice'
              page.delay 3 do
                page.visual_effect :toggle_blind, 'notice'
              end
            end
          end
        end
      end
    else
      render :update do | page |
        page.replace_html "user_detail_form", :partial => "profile"
      end
    end
  end
  
  def add_phone
    user = current_user
    @user_wireless_profile = UserWirelessProfile.new( params[ :user_wireless_profile ] )
    @user_wireless_profile.user = user
    if @user_wireless_profile.save
      render :update do | page |
        page.insert_html :bottom, 'phone_list', :partial => "phone", :locals => { :phone => @user_wireless_profile }
        page.replace_html "user_wireless_profile_form", :partial => "user_wireless_profile"
        page.replace_html "notice", "Phone added."
        page.visual_effect :toggle_blind, 'notice'
        page.delay 3 do
          page.visual_effect :toggle_blind, 'notice'
        end
      end
    else
      render :update do | page |
        page.replace_html "user_wireless_profile_form", :partial => "user_wireless_profile"
      end
    end    
  end
  
  def remove_phone
    @user_wireless_profile = UserWirelessProfile.find( params[ :phone_id ] )
    @user_wireless_profile.destroy
    user = current_user
    render :update do | page |
      page.replace_html "phone_list", :partial => "phone", :collection => user.user_wireless_profiles
    end
  end
  
  def add_location
    user = current_user
    @user_location = UserLocation.new( params[ :user_location ] )
    @user_location.user = user
    if @user_location.save
      render :update do | page |
        page.insert_html :bottom, 'location_list', :partial => "location", :locals => { :location => @user_location }
        page.replace_html "user_location_form", :partial => "user_location"
        page.replace_html "notice", "Place added."
        page.visual_effect :toggle_blind, 'notice'
        page.delay 3 do
          page.visual_effect :toggle_blind, 'notice'
        end
      end
    else
      render :update do | page |
        page.replace_html "user_location_form", :partial => "user_location"
      end
    end    
  end
  
  def remove_location
    @user_location = UserLocation.find( params[ :user_location_id ] )
    @user_location.destroy
    user = current_user
    render :update do | page |
      page.replace_html "location_list", :partial => "location", :collection => user.user_locations
    end
  end

end
