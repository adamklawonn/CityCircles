set :application, "citycircles"

set :scm, :git
set :repository,  "git://github.com/adamklawonn/CityCircles.git"
set :branch, "master"
set :deploy_via, :remote_cache

role :web, "69.164.199.238"                          # Your HTTP server, Apache/etc
role :app, "69.164.199.238"                          # This may be the same as your `Web` server
role :db,  "69.164.199.238", :primary => true # This is where Rails migrations will run

set :deploy_to, "/var/www-apps/#{application}"

set :user, "capy"
default_run_options[:pty] = true
set :ssh_options, { :forward_agent => true }

require 'config/deploy/capistrano_database'

namespace :deploy do
  
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  task :after_update_code, :roles => :app do
    %w{user_details}.each do |share|
      run "rm -rf #{release_path}/public/#{share}"
      run "mkdir -p #{shared_path}/system/#{share}"
      run "ln -nfs #{shared_path}/system/#{share} #{release_path}/public/#{share}"
    end
  end
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
    
end