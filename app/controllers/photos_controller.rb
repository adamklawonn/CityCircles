class PhotosController < ApplicationController
  
  before_filter :find_photoable
  
  def create
      @photo = @photoable.photos.new( params[ :photo ] )
      @photo.author_id = current_user.id
      @photo.save!
      respond_to do |format|
        format.html { redirect_to :controller => @photoable.class.to_s.tableize.downcase, :action => :show, :id => @photoable.id }
      end
    end
  
  private

  def find_photoable
    # Get the class name of the type for which the photo is being created
    klass = params[ :photoable_type ].camelize.constantize
    # Set photoable as an instance variable available to all methods to aid in creating photos for each model that uses photoable.
    @photoable = klass.find( params[ :photoable_id ] )
  end
  
end
