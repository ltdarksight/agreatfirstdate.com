Agreatfirstdate::Application.configure do
  config.action_mailer.delivery_method = :sendmail

  # Devise mailer needs this option
  config.action_mailer.default_url_options = { :host => 'agreatfirstdate.rubybakers.com' }

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  config.assets.precompile += ['users.css', "ui.coverflow.js", "sylvester.js", "transformie.js"]
end
