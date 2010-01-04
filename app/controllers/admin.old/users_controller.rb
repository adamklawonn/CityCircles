class Admin::UsersController < Admin::AdminController
  
  active_scaffold :user do | config |
    config.list.columns = [ :login, :email, :roles, :created_at ]
    config.create.columns = [ :login, :email, :password, :password_confirmation, :roles ]
    config.update.columns = [ :login, :email, :password, :password_confirmation, :roles ]
  end
  
end
