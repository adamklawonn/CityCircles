class InterestPointsController < ApplicationController
  
  def show
    @poi = InterestPoint.find( params[ :id ] )
    @default_map = @poi.map
    @map = Map.generate_poi_gmap( @poi )
  end
  
end
