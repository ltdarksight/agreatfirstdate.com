Agreatfirstdate::Application.configure do
  config.action_mailer.delivery_method = :sendmail
  
  # Devise mailer needs this option
  config.action_mailer.default_url_options = { :host => 'agreatfirstdate.rubybakers.com' }
end