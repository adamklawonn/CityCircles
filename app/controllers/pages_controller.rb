class PagesController < ApplicationController
  
  def show
    @page = Page.find_by_shortname params[ :shortname ]
  end
  
  def contact
  end
  
end
