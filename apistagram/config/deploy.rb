set :application, "cakesta"
set :repository,  "git@github.com:CraigMCF/apistagram.git"

set :scm, :git
set :user, "deployer"
set :branch, "master"

set :use_sudo, false
set :deploy_via, :remote_cache

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :keep_releases, 3

set :deploy_to, "/home/deployer/sites/#{application}"

role :web, "66.175.221.151"                          # Your HTTP server, Apache/etc
role :app, "66.175.221.151"                          # This may be the same as your `Web` server
role :db,  "66.175.221.151", :primary => true        # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do
    run "cd #{current_path}/apistagram && RAILS_ENV=production script/delayed_job stop"
  end
  task :stop do
    run "cd #{current_path}/apistagram && RAILS_ENV=production script/delayed_job start"
  end

  desc "Restarting Passenger with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'apistagram', 'tmp','restart.txt')}"
  end

  desc "Symlink shared resources on each release - not used"
  task :symlink_shared, :roles => :app do
    run "ln -nfs #{shared_path}/database.yml #{release_path}/apistagram/config/database.yml"
    # run "cd #{release_path}/apistagram && sudo bundle install --without test development"
    run "cd #{release_path}/apistagram && rake RAILS_ENV=production RAILS_GROUPS=assets assets:precompile"
    # migrate
  end 
end

after "deploy:update_code", "deploy:symlink_shared", "deploy:cleanup"