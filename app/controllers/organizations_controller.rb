class OrganizationsController < ApplicationController
  
  def index
    @organizations = Organization.find( :all, :include => :organization_members, :conditions => [ 'organization_members.user_id = ?', current_user.id ] )
  end
  
  def show
    @organization = Organization.find( params[ :id ] )
  end
  
  def new_ad_campaign
    @ad = Ad.new
    @ad.organization_id = params[ :id ]
    render :update do | page |
      page.replace_html "new_campaign", :partial => 'promos/ad', :locals => { :ad => @ad }
    end
  end
  
  def new_sms_campaign
    @promo = Post.new
    render :update do | page |
      page.replace_html "new_campaign", :partial => 'promos/sms'
    end
  end
  
  def new_email_campaign
    @promo = Post.new
    render :update do | page |
      page.replace_html "new_campaign", :partial => 'promos/email'
    end
  end
  
  def create_ad_campaign
    @ad = Ad.new( params[ :ad ] )
    if @ad.save
      render :update do | page |
        page.replace_html "new_campaign", ""
        page.replace_html "notice", "Place added."
        page.visual_effect :toggle_blind, 'notice'
        page.delay 3 do
          page.visual_effect :toggle_blind, 'notice'
        end
      end
    else
      render :update do | page |
        page.replace_html "new_campaign", :partial => 'promos/ad', :locals => { :ad => @ad }
      end
    end
  end
  
  def create_sms_campaign( post )
    
  end
  
  def create_email_campaign( post )
    
  end
  
end
