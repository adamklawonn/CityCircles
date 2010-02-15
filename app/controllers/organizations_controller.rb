class OrganizationsController < ApplicationController
  
  def index
    @organizations = Organization.find( :all, :include => :organization_members, :conditions => [ 'organization_members.user_id = ?', current_user.id ] )
  end
  
  def show
    @organization = Organization.find( params[ :id ] )
    @pending_campaigns = Ad.find( :all, :conditions => [ '( ? between starts_at and ends_at ) and is_approved = ? and organization_id = ?', Time.now, false, @organization.id ] )
    @current_campaigns = Ad.find( :all, :conditions => [ '( ? between starts_at and ends_at ) and is_approved = ? and organization_id = ?', Time.now, true, @organization.id ] )
    @past_campaigns = []
  end
  
  def new_ad_campaign
    @ad = Ad.new
    @ad.organization_id = params[ :id ]
    render :update do | page |
      page.replace_html "new_campaign", :partial => 'promos/ad', :locals => { :ad => @ad }
    end
  end
  
  def new_promo_campaign
    
    @promo = Promo.new
    @promo.organization_id = params[ :id ]
    @interest_points = InterestPoint.find( :all )
    @post = Post.new
    @post.post_type = PostType.find_by_shortname( 'promos' )
    @post.interest_point = @interest_points.first
    
    render :update do | page |
      page.replace_html "new_campaign", :partial => 'promos/promo'
    end
  end
  
  def update_promo_post_map
    @poi = InterestPoint.find( params[ :interest_point_id ] )
    render :update do | page |
      page.replace_html "promo_post_map", :partial => "maps/promo_post_map", :locals => { :poi => @poi }
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
  
  def create_promo_campaign

    @promo = Promo.new( params[ :promo ] )
    @promo.organization_id = params[ :promo_organization_id ]
    @promo.author_id = current_user.id
    @interest_points = InterestPoint.find( :all )
    
    @post = Post.new( params[ :post ] )
    @post.post_type = PostType.find_by_shortname( 'promos' )
    @post.interest_point = @interest_points.first
    @post.lat = params[ :lat ]
    @post.lng = params[ :lng ]
    @post.map_layer = MapLayer.find_by_shortname( 'promos' )
    @post.author_id = current_user.id

    @promo_starts_at_date = params[ :promo_starts_at_date ]
    @promo_starts_at_time = params[ :promo_starts_at_time ]
    @promo_ends_at_date = params[ :promo_ends_at_date ]
    @promo_ends_at_time = params[ :promo_ends_at_time ]
         
    begin
      starts_at_date = DateTime.parse( @promo_starts_at_date + " " + @promo_starts_at_time )
      ends_at_date = DateTime.parse( @promo_ends_at_date + " " + @promo_ends_at_time )
    rescue
      starts_at_date = nil
      ends_at_date = nil
    end
    
    @promo.starts_at = starts_at_date
    @promo.ends_at = ends_at_date
    @promo.post = @post
    puts @post.valid?
    puts @post.errors.to_json
    if @promo.save
      responds_to_parent do
        render :update do | page |
          page.replace_html "new_campaign", ""
          page.replace_html "notice", "Promo is now pending approval."
          page.visual_effect :toggle_blind, 'notice'
          page.delay 3 do
            page.visual_effect :toggle_blind, 'notice'
          end
        end
      end
    else
      responds_to_parent do
        render :update do | page |
          page.replace_html "new_campaign", :partial => 'promos/promo', :locals => { :promo => @promo }
        end
      end
    end
  end
  
end
