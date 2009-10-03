set :application, "citycircles"

set :scm, :git
set :repository,  "git://github.com/adamklawonn/CityCircles.git"
set :branch, "master"
set :deploy_via, :remote_cache

role :web, "67.23.22.72"                          # Your HTTP server, Apache/etc
role :app, "67.23.22.72"                          # This may be the same as your `Web` server
role :db,  "67.23.22.72", :primary => true # This is where Rails migrations will run

set :deploy_to, "/var/www-apps/#{application}"

set :user, "capy"
set :ssh_options, { :forward_agent => true }

require 'config/deploy/capistrano_database'

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end  
end