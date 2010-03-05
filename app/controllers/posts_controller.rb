class PostsController < ApplicationController
  
  before_filter :require_user, :only => [ :new, :create ]
  
  def index
    
    @post_type = PostType.find_by_shortname params[ :shortname ]
    
    if params[ :interest_point_id ] != nil
      # Posts near interest point.
      if params[ :interest_point_id ] != nil
        @poi = InterestPoint.find params[ :interest_point_id ]
        @posts = Post.find( :all, :conditions => [ 'interest_point_id = ? and post_type_id = ?', @poi.id, @post_type.id ], :origin => [ @poi.lat, @poi.lng ], :within => 0.3, :order => 'created_at desc' )
      else
        @posts = Post.find( :all, :conditions => [ 'post_type_id = ?', @post_type.id ], :order => 'created_at desc' )
      end
    else
      # All posts.
      @posts = Post.find( :all, :include => [ :post_type, :map_layer ] )
    end
    
    respond_to do | format |
      format.html
      format.atom { render :index, :layout => false }
      format.json { render :json => @posts.to_json( :include => [ :post_type, :map_layer ] ) }
    end
    
  end  
  
  def new
  
    @post = Post.new
    @post.post_type = PostType.find_by_shortname( params[ :pt ] )
    @post.interest_point = InterestPoint.find( params[ :poi_id ] )
  
  end
  
  def create
  
    @post = Post.new params[ :post ]
    @post.short_headline = @post.headline[ 0..40 ]
    @post.lat = params[ :lat ]
    @post.lng = params[ :lng ]
    @post.interest_point_id = params[ :interest_point_id ]
    @post.post_type = PostType.find( params[ :post_type_id ] )
    @post.map_layer = MapLayer.find_by_shortname( @post.post_type.shortname )
    @post.author_id = current_user.id
    
    # if event capture start and end dates/times
    event_post_type = PostType.find_by_shortname( "events" )
    if @post.post_type_id == event_post_type.id

      @event_starts_at_date = params[ :event_starts_at_date ]
      @event_starts_at_time = params[ :event_starts_at_time ]
      @event_ends_at_date = params[ :event_ends_at_date ]
      @event_ends_at_time = params[ :event_ends_at_time ]
           
      begin
        starts_at_date = DateTime.parse( @event_starts_at_date + " " + @event_starts_at_time )
        ends_at_date = DateTime.parse( @event_ends_at_date + " " + @event_ends_at_time )
      rescue
        starts_at_date = nil
        ends_at_date = nil
      end
      
      event = Event.new( :starts_at => starts_at_date, :ends_at => ends_at_date )
      @post.event = event
      @event = @post.event
    end
    
    # post attachments
    if params[ :post_attachment_captions ] != nil and params[ :post_attachment_files ] != nil
      params[ :post_attachment_captions ].each_key do | key |
        @post_attachment = PostAttachment.new :caption => params[ :post_attachment_captions ][ key ], :attachment => params[ :post_attachment_files ][ key ]
        @post.post_attachments << @post_attachment
      end
    end
    
    if @post.save
      flash[ :notice ] = "Post created."
      redirect_to interest_point_url( @post.interest_point ) 
    else
      # display worst error dialog ever
      flash[ :error ] = "There is a problem with your post. Please double check the required fields."
      render :new
    end
    
  end
  
  def show
    @post = Post.find params[ :id ]
    @comment = Comment.new
    render :show
  end
  
  def news
    @post = Post.find params[ :id ]
    @comment = Comment.new
    render :show
  end
  
  def events
    @post = Post.find params[ :id ]
    @comment = Comment.new
    render :show
  end
  
  def promos
    @post = Post.find params[ :id ]
    @comment = Comment.new
    render :show
  end
  
  def networks
    @post = Post.find params[ :id ]
    @comment = Comment.new
    render :show
  end
  
  def stuff
    @post = Post.find params[ :id ]
    @comment = Comment.new
    render :show
  end
  
  def fixit
    @post = Post.find params[ :id ]
    @comment = Comment.new
    render :show
  end

  def all_news
    @post_type = PostType.find_by_shortname( "news" )
    @posts = Post.find :all, :conditions => [ "post_type_id = ?", @post_type.id ], :order => "created_at desc"
    respond_to do | format |
      format.html{ render :index }
      format.atom { render :index, :layout => false }
    end
  end
  
  def all_events
    @post_type = PostType.find_by_shortname( "events" )
    @posts = Post.find :all, :conditions => [ "post_type_id = ?", @post_type.id ], :order => "created_at desc"
    respond_to do | format |
      format.atom { render :index, :layout => false }
    end
  end
  
  def all_promos
    @post_type = PostType.find_by_shortname( "promos" )
    @posts = Post.find :all, :conditions => [ "post_type_id = ?", @post_type.id ], :order => "created_at desc"
    respond_to do | format |
      format.atom { render :index, :layout => false }
    end
  end
  
  def all_networks
    @post_type = PostType.find_by_shortname( "network" )
    @posts = Post.find :all, :conditions => [ "post_type_id = ?", @post_type.id ], :order => "created_at desc"
    respond_to do | format |
      format.atom { render :index, :layout => false }
    end
  end
  
  def all_stuff
    @post_type = PostType.find_by_shortname( "stuff" )
    @posts = Post.find :all, :conditions => [ "post_type_id = ?", @post_type.id ], :order => "created_at desc"
    respond_to do | format |
      format.atom { render :index, :layout => false }
    end
  end
  
  def all_fixit
    @post_type = PostType.find_by_shortname( "fixit" )
    @posts = Post.find :all, :conditions => [ "post_type_id = ?", @post_type.id ], :order => "created_at desc"
    respond_to do | format |
      format.atom { render :index, :layout => false }
    end
  end
  
  def search
    @posts = []
  end

end
