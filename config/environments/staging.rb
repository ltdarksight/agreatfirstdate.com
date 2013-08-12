Agreatfirstdate::Application.configure do
  config.action_mailer.delivery_method = :smtp

  # Devise mailer needs this option
  config.action_mailer.default_url_options = { :host => 'agreatfirstdate.devmen.com' }
  config.app_host = 'agreatfirstdate.devmen.com'

  config.action_mailer.default charset: "utf-8"
  config.action_mailer.smtp_settings = {
    enable_starttls_auto: false
  }

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = false

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = false

  config.assets.precompile += %w( welcome.css )
  config.action_mailer.default charset: "utf-8"
  config.action_mailer.smtp_settings = {
    enable_starttls_auto: false
  }
  config.stripe.api_key = 'sk_test_cRlJ37wjQVw2CdpzNVvPFhJr'
  config.stripe.publishable_key = 'pk_test_7scxEBg7rY2Eas7S0W4DoX9B'
end
