class Admin::AdminController < ApplicationController
  
  layout 'admin'
  
  before_filter :require_user
  
  def index
    redirect_to :controller => "admin/inbox", :action => "index"
  end
  
end
