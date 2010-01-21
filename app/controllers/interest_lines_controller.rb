class InterestLinesController < ApplicationController
  
  def index
    @pois = InterestLine.gmap_json(params[:map_id])
    respond_to do | format |
      format.json { render :json => @pois }
    end
  end
  
end
