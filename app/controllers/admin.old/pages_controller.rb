class Admin::PagesController < Admin::AdminController
  
  active_scaffold :pages do | config |
    config.list.columns = [ :title, :shortname, :show_in_navigation, :description, :author, :sort, :created_at ]
    config.list.sorting = { :sort => :asc }
    config.create.columns = [ :title, :shortname, :show_in_navigation, :description, :body, :sort, :author ]
    config.update.columns = [ :title, :shortname, :show_in_navigation, :description, :body, :sort, :author ]
  end
  
end
