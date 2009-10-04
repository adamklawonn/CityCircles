class InterestPointsController < ApplicationController
  
  def show
    @poi = InterestPoint.find( params[ :id ])
  end
  
end
