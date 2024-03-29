CloudFunded::Application.configure do
  
  ENV['AMAZON_S3_BUCKET'] = 'cloud_funded'
  ENV['DISQUS_APPNAME'] = 'cloudfundedstaging'
  ENV['DISQUS_DEVMODE'] = '0'
  ENV['DWOLLA_KEY'] = 'hNZPFYpFeDb2KN759OD98e+brYTW6xXnH7CXqz+Axv8nFcXJno'
  ENV['DWOLLA_SECRET'] = 'ldwMpY70KH0zf72CaqgTjsZDyP8JhhwsSfAlvl0CWIJcdmg+SJ'
  ENV['FACEBOOK_APP_ID'] = '336588343062874'
  ENV['FACEBOOK_SECRET_KEY'] = '03ac974371620fae08891f673160117b'
  ENV['OPENGRAPH_NAMESPACE'] = 'cloudfunded'
  ENV['SENDGRID_PASSWORD'] = 'B@rnD00ez!'
  ENV['SENDGRID_USERNAME'] = 'cloudfunded_staging'
  ENV['TWITTER_APP_ID'] = 'HNdNinpVKKXKzkOjet2g'
  ENV['TWITTER_SECRET_KEY'] = 'NcIejMNhs8S3XvzvM6Xwj3PUhUQDbpsOqt1k4g50'

  Dwolla::Transaction.test_mode = true

  config.action_mailer.default :charset => "utf-8"
  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => 'cloudfunded.com'
  }
  ActionMailer::Base.delivery_method = :smtp

  CloudFunded::Application.config.paperclip_storage = {
    :storage => :s3,
    :s3_protocol => '',
    :bucket => ENV['AMAZON_S3_BUCKET'],
    :s3_credentials => {
      :access_key_id => 'AKIAIDEFW5P6AQLRXWGQ',
      :secret_access_key => '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'
    }
  }
  
  # Settings specified here will take precedence over those in config/application.rb

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

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5
    
  config.action_mailer.default_url_options = { :host => 'demo.cloudfunded.com' }
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true

end
