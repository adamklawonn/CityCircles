class NewsController < ApplicationController
  
  def index
    @poi = InterestPoint.find params[ :interest_point_id ]
    @news = News.find( :all, :conditions => [ 'interest_point_id = ?', @poi.id ], :origin => [ @poi.lat, @poi.lng ], :within => 0.3, :order => 'created_at desc' )
    
    respond_to do | format |
      format.html
      format.xml { render :index, :layout => false }
    end
    
  end
  
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
  
  def show
    @news = News.find( params[ :id ] )
  end
  
end
