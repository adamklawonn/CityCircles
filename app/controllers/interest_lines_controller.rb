class InterestLinesController < ApplicationController
  
  def index
    @pois = InterestLine.find( :all, :conditions => [ "map_id = ?", params[ :map_id ] ], :include => :map_layer )
    respond_to do | format |
      format.json { render :json => @pois.to_json( :include => :map_layer ) }
    end
  end
  
end
