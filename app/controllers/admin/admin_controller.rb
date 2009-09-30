class Admin::AdminController < ApplicationController
  
  layout 'admin'
  
  before_filter :require_user
  
  def index
    redirect_to :controller => "inbox", :action => "index"
  end
  
end
