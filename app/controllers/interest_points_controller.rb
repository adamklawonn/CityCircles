class InterestPointsController < ApplicationController
  
  def show
    @poi = InterestPoint.find( params[ :id ] )
    @default_map = @poi.map
  end
  
end
