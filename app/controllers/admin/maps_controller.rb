class Admin::MapsController < Admin::AdminController
  
  def index
    @maps = Map.find( :all )
  end
  
end
