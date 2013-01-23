require 'instagram'

Instagram.configure do |config|
  config.client_id = Settings.instagram.id
  config.client_secret = Settings.instagram.secret
end