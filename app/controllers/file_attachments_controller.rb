class FileAttachmentsController < ApplicationController
  
  layout 'file_attachments'
  
  def new
    @file_attachment = FileAttachment.new
  end
  
  def create
    @file_attachment = FileAttachment.new( params[ :file_attachment ] )
    @file_attachment.author_id = current_user.id
    if @file_attachment.save
      render :json => { :status => :ok }
    else
      render :json => { :status => :error }
    end
  end
  
end
