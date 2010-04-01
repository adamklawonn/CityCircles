class SuggestionsController < ApplicationController
  
  def new
    @suggestion = Suggestion.new
  end
  
  def create
    
    @suggestion = Suggestion.new params[ :suggestion ]
            
      if @suggestion.save
        flash[ :notice ] = "Thank you for your suggestion!"
        redirect_to :back
      else
        redirect_to :back  
      end
    
  end
  
end
