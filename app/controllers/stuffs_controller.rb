class StuffsController < ApplicationController
  
  def index
    @poi = InterestPoint.find params[ :interest_point_id ]
    @stuffs = Stuff.find( :all, :conditions => [ 'interest_point_id = ?', @poi.id ], :origin => [ @poi.lat, @poi.lng ], :within => 0.3, :order => 'created_at desc' )
    
    respond_to do | format |
      format.html
      format.xml { render :index, :layout => false }
    end
    
  end
  
  def new
    @stuff = Stuff.new
  end
  
  def create
    
    @stuff = Stuff.new params[ :stuff ]
    @stuff.lat = params[ :lat ]
    @stuff.lng = params[ :lng ]
    @stuff.interest_point_id = params[ :interest_point_id ]
    @stuff.map_layer_id = MapLayer.find_by_shortname( "stuff" ).id
    @stuff.map_icon_id = MapIcon.find_by_shortname( "stuff" ).id
    @stuff.author_id = current_user.id
    
    if request.xhr?
      if @stuff.save
        flash[ :notice ] = "Stuff posted."
        render :update do | page |
          page << "$j( '#postcontent' ).dialog( 'close' );"
          page.reload 
        end
      else
    
      end
    end
    
  end
  
  def show
    @stuff = Stuff.find( params[ :id ] )
  end
  
end
