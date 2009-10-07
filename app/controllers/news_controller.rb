class NewsController < ApplicationController
  
  def new
    @news = News.new
  end
  
  def create
    
    @news = News.new params[ :news ]
    @news.lat = params[ :lat ]
    @news.lng = params[ :lng ]
    @news.interest_point_id = params[ :interest_point_id ]
    @news.map_layer_id = MapLayer.find_by_shortname( "news" ).id
    @news.map_icon_id = MapIcon.find_by_shortname( "news" ).id
    @news.author_id = current_user.id
    
    if request.xhr?
      if @news.save
        flash[ :notice ] = "News item posted."
        render :update do | page |
          page << "$j( '#postcontent' ).dialog( 'close' );"
          page.reload 
        end
      else
    
      end
    end
    
  end
  
end
