require 'rvm/capistrano'
require 'bundler/capistrano'
require 'capistrano/ext/multistage'

set :whenever_command, 'bundle exec whenever'
set :whenever_environment, defer { stage }
set :whenever_identifier, defer { "#{application}_#{stage}" }
require 'whenever/capistrano'

set :application, 'agreatfirstdate'
set :repository,  'git@github.com:ltdarksight/agreatfirstdate.com.git'
#set :deploy_via, :copy
#set :copy_strategy, :export
set :rvm_type, :system
set :stages, %w(staging production)
set :default_stage, 'staging'
set :keep_releases, 10

set :scm, :git

ssh_options[:forward_agent] = true
default_run_options[:pty] = true

after "deploy:finalize_update", "deploy:create_symlink_db", 'deploy:migrate'

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Symlinks"
  task :create_symlink_db, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{deploy_to}/shared/settings/#{rails_env}.yml #{release_path}/config/settings/#{rails_env}.yml"
    run "ln -nfs /home/taste #{release_path}/public/taste"
  end

  desc "Reload the database with seed data"
  task :seed do
    run "cd #{current_path} && bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end
end

require './config/boot'
require 'airbrake/capistrano'
