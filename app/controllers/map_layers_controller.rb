class MapLayersController < ApplicationController
  
  def index
    
    @map_layers = MapLayer.find( :all, :conditions => [ "map_id = ?", params[ :map_id ] ], :include => :interest_points )
    
    respond_to do | format |
      format.json { render :json => @map_layers }
    end
    
  end
  
end
