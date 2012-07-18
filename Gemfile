source 'https://rubygems.org'

gem 'rails', '3.2.6'

gem 'pg'
gem 'jquery-rails'
gem 'haml-rails'
gem 'devise', '2.1'
gem 'omniauth-dwolla'
gem 'omniauth-facebook'
gem 'devise-encryptable'
gem 'friendly_id'
gem 'responders', '~> 0.9.1'
gem 'paperclip'
gem 'aws-sdk'
gem 'recaptcha', :require => 'recaptcha/rails'
gem 'cancan'
gem 'mercury-rails', git: 'https://github.com/jejacks0n/mercury.git', ref: '1f7b142'
gem 'default_value_for'
gem 'httparty'
gem 'wicked'
gem 'dwolla', git: 'https://github.com/tylergannon/dwolla.git'
# gem 'dwolla', path: '/Users/tyler/src/3rd_party/dwolla'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-ui-rails'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'guard-spork'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'spork', '1.0.0rc3'
  gem 'timecop'
end

group :test do
  gem 'webmock'
  gem 'vcr'
  gem 'poltergeist'
  gem 'cucumber-rails'
  gem 'database_cleaner'
  gem "capybara-webkit"
end

group :deployment do
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'rvm-capistrano'
end
