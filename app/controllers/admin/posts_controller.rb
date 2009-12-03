class Admin::PostsController < Admin::AdminController

  active_scaffold :post do | config |
    config.list.columns = [ :headline, :author, :created_at ]
    config.create.columns = [ :headline, :body, :author ]
    config.update.columns = [ :headline, :body, :author ]
  end

end
