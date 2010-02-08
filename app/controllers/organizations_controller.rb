class OrganizationsController < ApplicationController
  
  def index
    
  end
  
  def show
    @organization = Organization.find( params[ :id ] )
  end
  
end
