class SuggestionsController < ApplicationController
  
  def new
    @suggestion = Suggestion.new
  end
  
  def create
    
    @suggestion = Suggestion.new params[ :suggestion ]
    
    if request.xhr?
      
      if @suggestion.save
        flash[ :notice ] = "Suggestion Submitted."
        render :update do | page |
          page.replace_html "notice", flash[ :notice ]
          page.reload
        end
      else
    
      end
    end
    
  end
  
end
