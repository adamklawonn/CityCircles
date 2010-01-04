class Admin::EventsController < Admin::AdminController

  active_scaffold :events do | config |
    config.list.columns = [ :headline, :author, :created_at ]
    config.create.columns = [ :headline, :body, :lat, :lng, :author ]
    config.update.columns = [ :headline, :body, :lat, :lng, :author ]
  end
  
end
