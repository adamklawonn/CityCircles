class Admin::OrganizationsController < Admin::AdminController
  
  active_scaffold :organizations do | config |
    config.list.columns = [ :name, :description, :author, :created_at, :updated_at ]
    config.create.columns = [ :name, :description, :lat, :lng, :author ]
    config.update.columns = [ :name, :description, :lat, :lng, :author ]
  end
  
end
