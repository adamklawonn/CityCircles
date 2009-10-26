class Admin::AdminController < ApplicationController
  
  layout 'admin'
  
  before_filter :require_user
  
  def index
    redirect_to :controller => "admin/inbox", :action => "index"
  end
  
  private
  
  def get_pages
    # Do nothing.
  end
  
  def new_suggestion
    # Do nothing.
  end
  
  def get_default_map
    # Do nothing.
  end
  
end
