source 'https://rubygems.org'

gem 'rails', '3.2.12'

# Views section
gem 'haml-rails'
gem 'twitter-bootstrap-rails'
gem 'less-rails'

# JS
gem 'jquery-rails'
gem 'jquery-ui-themes'
gem 'remotipart', '~> 1.0'

# Backbone
gem 'backbone-on-rails'
gem 'haml_assets'

# DB section
gem 'pg'

# Settings
gem 'rails_config'

# Geolocation
gem 'geokit'

# Auth
gem 'devise', '~> 2.2.4'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-instagram'
gem 'cancan'

# Facebook integration
gem 'koala'

# WYSIWYG Editor
gem 'tinymce-rails'

# Instagram integration
gem 'instagram', :git => 'https://github.com/manzhikov/instagram-ruby-gem'

# Forms
gem 'simple_form'

# Errors
gem 'airbrake'

# Cron Jobs
gem 'whenever', :require => false

gem 'carrierwave'
gem 'carrierwave-meta', :git => 'git://github.com/manzhikov/carrierwave-meta.git'
gem 'fog'
gem 'rmagick'
gem 'jcrop-rails'
gem 'rails3_acts_as_paranoid', '~>0.2.0'
gem 'stripe'

# Paginate
gem 'will_paginate', '~> 3.0'

gem "unicorn", "~> 4.6.2"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'therubyracer'
end

group :development do
  gem 'capistrano'
  gem 'rvm-capistrano'
  gem 'capistrano_colors'
  gem 'capistrano-ext'
  gem 'letter_opener'
  gem "capistrano-unicorn", "~> 0.1.6"
  gem "quiet_assets", "~> 1.0.1"
  gem "foreman"
  gem "thin"
end

group :test do
  gem 'factory_girl_rails'
  gem 'cucumber-rails', '1.1.1'
end

group :development, :test do
  gem 'faker'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'webrat'
  gem 'database_cleaner'
  gem 'capybara'
  # gem 'capybara-webkit'
  gem 'pickle', '0.4.10'
  gem 'shoulda', '2.11.3'
  gem 'simplecov'
  gem 'mocha'
  gem 'spork', '0.9.0.rc9'
  gem 'cucumber', '1.1.0'
  gem 'guard-cucumber', '0.7.3'
end
