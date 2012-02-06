set :dns_name, "178.79.172.111"

role :web, dns_name                          # Your HTTP server, Apache/etc
role :app, dns_name                          # This may be the same as your `Web` server
role :db,  dns_name, :primary => true        # This is where Rails migrations will run

set :deploy_to, "/srv/#{application}_staging"
set :normalize_asset_timestamps, false

set :rails_env, 'staging'
set :branch, 'master'
set :use_sudo, false

set :user, "#{application}_staging"
set :password, 'Iegh0Xahsaewaiwaeyaa'
set :port, 22
