CloudFunded::Application.configure do
  
  Dwolla::Transaction.test_mode = true
  
  if `hostname`.strip == 'li421-113'
    config.action_mailer.default_url_options = { :host => 'dev.cloudfunded.com' }
    ENV['DWOLLA_KEY'] = 'FH8ROFZyhOd5Xp9mU3YpV5nVQQhPZ16PfWBV/FUH4eNZHKbHZR'
    ENV['DWOLLA_SECRET'] = 'FWtuQE6DY2NakB20AnjdJdvt0Jo8QapDUj2c2BsODJgA4+Yndq'
    ENV['facebook_app_id'] = '395940067129740'
    ENV['facebook_secret_key'] = '4a93f54a78f136b5f551ef0fbe15bcd4'
  else
    config.action_mailer.default_url_options = { :host => 'local.cloudfunded.com:3000' }
    ENV['DWOLLA_KEY'] = 'onyiTxhgtndNywPHqTJ2GJ98srT1F88h1EAnsKmYLMkKaqJqsa'
    ENV['DWOLLA_SECRET'] = 'qyXerrvhvxj6fvsngIvMkS8du9E0Y4LX7ObDsgIRMKr0WOzBdZ'
    ENV['facebook_app_id'] = '125298410939354'
    ENV['facebook_secret_key'] = '39a8462763d22977e474c3bd01d63f10'
  end

  ENV['OPENGRAPH_NAMESPACE'] = 'cloudfundeddev'

  # https://www.dwolla.com/oauth/v2/authenticate?client_id=onyiTxhgtndNywPHqTJ2GJ98srT1F88h1EAnsKmYLMkKaqJqsa&response_type=code&redirect_uri=http%3A%2F%2Flocal.cloudfunded.com%3a3000%2fmembers%2fauth%2fdwolla%2fcallback&scope=send%accountinfofull
  # 
  # https://www.dwolla.com/oauth/v2/authenticate?response_type=code&client_id=wGcz6BfJ34N9oRvdtY3d7ReIUoc28ds3Pn3LmSCCtD5CNluCwB&redirect_uri=http%3A%2F%2Flocal.cloudfunded.com%3A3000%2Fmembers%2Fauth%2Fdwolla%2Fcallback&scope=accountinfofull%7Csend
    
  ENV['DWOLLA_SEND'] = 'https://www.dwolla.com/oauth/rest/testapi/send'
  
  ENV['AMAZON_S3_BUCKET'] = 'cloud_funded_sandbox'
  

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
  
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  
  ENV['SENDGRID_USERNAME'] = 'cloudfunded_development'
  ENV['SENDGRID_PASSWORD'] = 'B@rnD00ez!'
end
