$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.

require 'rvm/capistrano'
require 'bundler/capistrano'
require 'capistrano/ext/multistage'

set :application, "agreatfirstdate"
set :repository,  "git@github.com:23ninja/agreatfirstdate.com.git"

set :stages, %w(staging)
set :default_stage, "staging"
set :keep_releases, 10

set :scm, :git

after 'deploy:update_code', 'deploy:symlink_db', 'assets:precompile'
after 'deploy', 'deploy:migrate'

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Symlinks the database.yml"
  task :symlink_db, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/database.yml #{release_path}/config/database.yml"
  end

  desc "Reload the database with seed data"
  task :seed do
    run "cd #{current_path} && rake db:seed RAILS_ENV=#{rails_env} --trace"
  end
end

namespace :assets do
  desc "Precompile Assets"
  task :precompile do
    run "cd #{release_path} && rake RAILS_ENV=#{rails_env} assets:precompile"
  end
end

require './config/boot'
require 'airbrake/capistrano'
