set :dns_name, "50.56.28.228"

role :web, dns_name                          # Your HTTP server, Apache/etc
role :app, dns_name                          # This may be the same as your `Web` server
role :db,  dns_name, :primary => true        # This is where Rails migrations will run

set :deploy_to, "/opt/apps/agreatfirstdate/staging"
set :normalize_asset_timestamps, false

set :rails_env, 'staging'
set :branch, 'devmen_staging'
set :use_sudo, false
# set :rvm_ruby_string, "1.9.3-p392@agreatfirstdate"

set :user, 'deploy'
set :port, 22
