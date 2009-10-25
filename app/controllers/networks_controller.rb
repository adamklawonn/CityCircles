class NetworksController < ApplicationController
  
  def index
    @poi = InterestPoint.find params[ :interest_point_id ]
    @networks = Network.find( :all, :conditions => [ 'interest_point_id = ?', @poi.id ], :origin => [ @poi.lat, @poi.lng ], :within => 0.3, :order => 'created_at desc' )
    
    respond_to do | format |
      format.html
      format.xml { render :index, :layout => false }
    end
    
  end
  
  def new
    @network = Network.new
  end
  
  def create
    
    @network = Network.new params[ :network ]
    @network.lat = params[ :lat ]
    @network.lng = params[ :lng ]
    @network.interest_point_id = params[ :interest_point_id ]
    @network.map_layer_id = MapLayer.find_by_shortname( "network" ).id
    @network.map_icon_id = MapIcon.find_by_shortname( "network" ).id
    @network.author_id = current_user.id
    
    if request.xhr?
      if @network.save
        flash[ :notice ] = "Network posted."
        render :update do | page |
          page << "$j( '#postcontent' ).dialog( 'close' );"
          page.redirect_to interest_point_url( @network.interest_point ) 
        end
      else
    
      end
    end
    
  end
  
  def show
    @network = Network.find( params[ :id ] )
  end
  
end
