load 'deploy/assets'
require 'bundler/capistrano'

role :web, "node1283.speedyrails.net"
role :app, "node1283.speedyrails.net"
role :db,  "node1283.speedyrails.net", :primary => true
set :application, "vocabtales"

set :repository, "git@github.com:town-techies/vocab.git"

set(:deploy_to) { "/var/www/apps/#{application}" }

set :user, "deploy"
set :password, "47NjQHT9Cp"
set :group, "www-data"

set :deploy_via, :remote_cache
set :scm, "git"
set :keep_releases, 5

after "deploy", "deploy:cleanup"
after "deploy:migrations", "deploy:cleanup"
after "deploy:update_code", "deploy:symlink_configs" #, "deploy:symlink_custom"

namespace :deploy do

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{deploy_to}/#{shared_dir}/tmp/restart.txt"
  end

  desc "Tasks to execute after code update"
  task :symlink_configs, :roles => [:app] do
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
    run "if [ -d #{release_path}/tmp ]; then rm -rf #{release_path}/tmp; fi; ln -nfs #{deploy_to}/#{shared_dir}/tmp #{release_path}/tmp"
  end

  desc "Custom Symlinks"
  task :symlink_custom, :roles => [:app] do
  end
  
  desc "Install bundles into application"
  task :install, :roles => [:app] do
    run "cd #{current_path} && LC_ALL='en_US.UTF-8' bundle install --deployment --without test"
  end

end
