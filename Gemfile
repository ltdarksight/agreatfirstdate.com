source 'https://rubygems.org'

gem 'rails', '3.2.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#Views section
gem 'haml-rails'

#DB section
gem 'pg'
gem 'sqlite3'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
# gem 'unicorn'

group :development do
  gem 'capistrano'
  gem 'capistrano_colors'
  gem 'capistrano-ext'
  gem 'thin' # webrick shows annoying WARN  Could not determine content-length of response body
end

group :development, :test do
  gem 'pry'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
end

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

