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
  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  VCR.configure do |c|
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
    config.use_transactional_fixtures = true

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    OmniAuth.config.test_mode = true
    
    config.before(:each, :type => :controller) do
      request.env["devise.mapping"] = Devise.mappings[:member]
    end

    config.include Devise::TestHelpers, :type => :controller
    config.include Devise::TestHelpers, :type => :view
    config.include Devise::TestHelpers, :type => :helper
    config.include Paperclip::Shoulda::Matchers
  end
  
  VCR.configure do |c|
    c.cassette_library_dir = 'fixtures/vcr_cassettes'
    c.hook_into :webmock # or :fakeweb
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.

end
