class Admin::SuggestionsController < Admin::AdminController
  
  active_scaffold :suggestion do | config |
    config.list.columns = [ :email, :body, :created_at ]
    config.create.columns = [ :email, :body, :created_at ]
    config.update.columns = [ :email, :body, :created_at ]
  end
  
end
