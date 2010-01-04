class Admin::MapsController < Admin::AdminController
  
  active_scaffold :map do | config |
    config.list.columns = [ :title, :shortname, :author ]
    config.create.columns = [ :title, :description, :shortname, :lat, :lng, :zoom, :author ]
    config.update.columns = [ :title, :description, :shortname, :lat, :lng, :zoom, :author ]
  end
  
end
