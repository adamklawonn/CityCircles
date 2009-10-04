class Admin::PagesController < Admin::AdminController
  
  active_scaffold :pages do | config |
    config.list.columns = [ :title, :shortname, :show_in_navigation, :description, :author, :created_at ]
    config.create.columns = [ :title, :shortname, :show_in_navigation, :description, :body, :page_order, :author ]
    config.update.columns = [ :title, :shortname, :show_in_navigation, :description, :body, :page_order, :author ]
  end
  
end
