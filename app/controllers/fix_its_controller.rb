class FixItsController < ApplicationController
  
  def index
    @poi = InterestPoint.find params[ :interest_point_id ]
    @fix_its = FixIt.find( :all, :conditions => [ 'interest_point_id = ?', @poi.id ], :origin => [ @poi.lat, @poi.lng ], :within => 0.3, :order => 'created_at desc' )
    
    respond_to do | format |
      format.html
      format.xml { render :index, :layout => false }
    end
    
  end
  
  def new
    @fix_it = FixIt.new
  end
  
  def create
    
    @fix_it = FixIt.new params[ :fix_it ]
    @fix_it.lat = params[ :lat ]
    @fix_it.lng = params[ :lng ]
    @fix_it.interest_point_id = params[ :interest_point_id ]
    @fix_it.map_layer_id = MapLayer.find_by_shortname( "fixit" ).id
    @fix_it.map_icon_id = MapIcon.find_by_shortname( "fixit" ).id
    @fix_it.author_id = current_user.id
    
    if request.xhr?
      if @fix_it.save
        flash[ :notice ] = "Fix It posted."
        render :update do | page |
          page << "$j( '#postcontent' ).dialog( 'close' );"
          page.redirect_to interest_point_url( @fix_it.interest_point ) 
        end
      else
    
      end
    end
    
  end
  
  def show
    @fix_it = FixIt.find( params[ :id ] )
  end
  
end
