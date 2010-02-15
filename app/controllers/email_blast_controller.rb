class EmailBlastController < ApplicationController
  
  before_filter :require_user
  
  def index
    @email_blasts = EmailBlast.find( :all, :conditions => [ 'was_sent = ?', 0 ], :order => 'send_at desc' )
    
    respond_to do | format |
      format.html
      format.xml { render :index, :layout => false }
    end
    
  end
  
  def show
    @email_blast = EmailBlast.find( params[ :id ] )
  end
  
end
