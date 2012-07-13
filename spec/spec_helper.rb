require 'rubygems'
require 'spork'

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

Spork.prefork do
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'vcr'
  require "paperclip/matchers"
  require "cancan/matchers"
  require 'capybara'
  require 'capybara/poltergeist'

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new app, debug: true, raise_errors: false
  end
  Capybara.javascript_driver = :poltergeist

    
  `ulimit -n 1000`  # Avoids "too many open file descriptors" error
  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  VCR.configure do |c|
    c.ignore_localhost = true
    c.cassette_library_dir = "#{::Rails.root}/spec/vcr_fixtures"
    c.hook_into :webmock # or :fakeweb
  end
  
  RSpec.configure do |config|
    # ## Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    # config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = false

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    OmniAuth.config.test_mode = true

    DatabaseCleaner.strategy = :truncation
    
    config.before(:each) do
      DatabaseCleaner.clean
    end
    
    config.before(:each, :type => :controller) do
      request.env["devise.mapping"] = Devise.mappings[:member]
    end

    config.include Devise::TestHelpers, :type => :controller
    config.include Devise::TestHelpers, :type => :view
    config.include Devise::TestHelpers, :type => :helper
    config.include Paperclip::Shoulda::Matchers
    config.include AdminMemberSignInHelper, type: :controller
    config.include MemberSignInHelper, type: :controller
    config.include AttachmentStubHelper, type: :controller
    config.include AttachmentStubHelper, type: :model
  end
  
  VCR.configure do |c|
    c.cassette_library_dir = 'fixtures/vcr_cassettes'
    c.hook_into :webmock # or :fakeweb
  end
end

Spork.each_run do
  FactoryGirl.reload
  CloudFunded::Application.reload_routes!
  Dir[Rails.root.join('spec/support/**/*.rb')].each{|f| load f}
  %w(cloud_funded extensions mercury).each do |dir|
    Dir[Rails.root.join("lib/#{dir}/**/*.rb")].each{|f| load f}
  end
end
