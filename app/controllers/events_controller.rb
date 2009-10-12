class EventsController < ApplicationController
  
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
