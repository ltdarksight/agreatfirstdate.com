Agreatfirstdate::Application.configure do
  config.action_mailer.delivery_method = :sendmail
  config.action_mailer.default_url_options = {:host => request.host_with_port}
end