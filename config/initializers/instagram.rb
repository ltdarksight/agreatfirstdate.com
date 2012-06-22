require 'instagram'

Instagram.configure do |config|
  config.client_id = Settings.send(Rails.env).oauth.instagram.id
  config.client_secret = Settings.send(Rails.env).oauth.instagram.secret
end