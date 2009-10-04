class PagesController < ApplicationController
  
  def show
    @page = Page.find_by_shortname params[ :shortname ]
  end
  
end
