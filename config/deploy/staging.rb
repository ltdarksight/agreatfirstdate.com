set :dns_name, '50.116.19.161'

role :web, dns_name                          # Your HTTP server, Apache/etc
role :app, dns_name                          # This may be the same as your `Web` server
role :db,  dns_name, :primary => true        # This is where Rails migrations will run

set :deploy_to, '/home/agreatfirstdate/staging'
set :normalize_asset_timestamps, false

set :rails_env, 'staging'
set :branch, 'staging'
set :use_sudo, false

set :user, 'agreatfirstdate'
set :port, 22
