CloudFunded::Application.configure do
  ENV['facebook_app_id'] = '125298410939354'
  ENV['facebook_secret_key'] = '39a8462763d22977e474c3bd01d63f10'
  
  ENV['DWOLLA_KEY'] = 'wGcz6BfJ34N9oRvdtY3d7ReIUoc28ds3Pn3LmSCCtD5CNluCwB'
  ENV['DWOLLA_SECRET'] = 'ie7Vaxw+uWuc8RJBC2FDapREC+DRYe4n0LaF4+2fN1CMH5PTfp'
  ENV['DWOLLA_SEND'] = 'https://www.dwolla.com/oauth/rest/testapi/send'
  

  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true
  
  config.action_mailer.default_url_options = { :host => 'local.cloudfunded.com:3000' }
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  
  ENV['SENDGRID_USERNAME'] = 'cloudfunded_development'
  ENV['SENDGRID_PASSWORD'] = 'B@rnD00ez!'
end
