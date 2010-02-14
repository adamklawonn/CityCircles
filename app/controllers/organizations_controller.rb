class OrganizationsController < ApplicationController
  
  def index
    @organizations = Organization.find( :all, :include => :organization_members, :conditions => [ 'organization_members.user_id = ?', current_user.id ] )
  end
  
  def show
    @organization = Organization.find( params[ :id ] )
    @pending_campaigns = Ad.find( :all, :conditions => [ '( ? between starts_at and ends_at ) and is_approved = ? and organization_id = ?', Time.now, false, @organization.id ] )
    @current_campaigns = []
    @past_campaigns = []
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
    
    @ad_starts_at_date = params[ :ad_starts_at_date ]
    @ad_starts_at_time = params[ :ad_starts_at_time ]
    @ad_ends_at_date = params[ :ad_ends_at_date ]
    @ad_ends_at_time = params[ :ad_ends_at_time ]
         
    begin
      starts_at_date = DateTime.parse( @ad_starts_at_date + " " + @ad_starts_at_time )
      ends_at_date = DateTime.parse( @ad_ends_at_date + " " + @ad_ends_at_time )
    rescue
      starts_at_date = nil
      ends_at_date = nil
    end
    
    @ad.starts_at = starts_at_date
    @ad.ends_at = ends_at_date
    puts @ad.valid?
    puts @ad.errors.to_json
    if @ad.save
      responds_to_parent do
        render :update do | page |
          page.replace_html "new_campaign", ""
          page.replace_html "notice", "Ad is now pending approval."
          page.visual_effect :toggle_blind, 'notice'
          page.delay 3 do
            page.visual_effect :toggle_blind, 'notice'
          end
        end
      end
    else
      responds_to_parent do
        render :update do | page |
          page.replace_html "new_campaign", :partial => 'promos/ad', :locals => { :ad => @ad }
        end
      end
    end
  end
  
  def create_sms_campaign( post )
    
  end
  
  def create_email_campaign( post )
    
  end
  
end
