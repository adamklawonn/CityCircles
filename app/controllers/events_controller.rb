class EventsController < ApplicationController
  
  def index
    @poi = InterestPoint.find params[ :interest_point_id ]
    @events = Event.find( :all, :conditions => [ 'interest_point_id = ?', @poi.id ], :origin => [ @poi.lat, @poi.lng ], :within => 0.3, :order => 'created_at desc' )
    
    respond_to do | format |
      format.html
      format.xml { render :index, :layout => false }
    end
    
  end
  
  def new
    @event = Event.new
  end
  
  def create
    
    @event = Event.new params[ :event ]
    @event.lat = params[ :lat ]
    @event.lng = params[ :lng ]
    @event.interest_point_id = params[ :interest_point_id ]
    @event.map_layer_id = MapLayer.find_by_shortname( "events" ).id
    @event.map_icon_id = MapIcon.find_by_shortname( "events" ).id
    @event.author_id = current_user.id
    
    if request.xhr?
      if @event.save
        flash[ :notice ] = "Event posted."
        render :update do | page |
          page << "$j( '#postcontent' ).dialog( 'close' );"
          page.reload 
        end
      else
    
      end
    end
    
  end
  
end
