class Admin::InterestsController < Admin::AdminController

  active_scaffold :interests do | config |
    config.list.columns = [ :name, :created_at ]
    config.create.columns = [ :name, :created_at ]
    config.update.columns = [ :name, :created_at ]
  end

end