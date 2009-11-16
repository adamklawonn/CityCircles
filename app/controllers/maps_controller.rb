class MapsController < ApplicationController
  
  def show
    
    @map = Map.find( params[ :id ] )
    respond_to do | format |
      format.xml { render :template => "maps/show", :layout => false }
    end
    
  end
  
  def next
    @map = Map.find_by_shortname( "lightrail" )    
  end
  
end
