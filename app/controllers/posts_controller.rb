class PostsController < ApplicationController

  def create
  
    @post = Post.new params[ :post ]
    @post.short_headline = @post.headline[ 0..40 ]
    @post.lat = params[ :lat ]
    @post.lng = params[ :lng ]
    @post.interest_point_id = params[ :interest_point_id ]
    @post.map_layer_id = MapLayer.find_by_shortname( "events" ).id
    @post.post_type_id = params[ :post_type_id ]
    @post.author_id = current_user.id
    
    if request.xhr?
  
      if @post.save
        flash[ :notice ] = "Post created."
        render :update do | page |
          page << "$j( '#postcontent' ).dialog( 'close' );"
          page.redirect_to interest_point_url( @post.interest_point ) 
        end
      else
        # Do nothing.
      end
  
    end
  
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
  
  def news
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

end
