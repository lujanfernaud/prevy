require 'simplecov'
SimpleCov.start 'rails' unless ENV['NO_COVERAGE']

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'support/support'

require 'capybara/rails'
require 'capybara/minitest'

require 'capybara-screenshot/minitest'
Capybara::Screenshot.prune_strategy = { keep: 10 }

Capybara.match = :prefer_exact
Capybara.asset_host = 'http://localhost:3000'

Capybara::Webkit.configure do |config|
  config.allow_url("gravatar.com")
  config.allow_url("api.mapbox.com")
  config.allow_url("api.tiles.mapbox.com")
end

require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! [Minitest::Reporters::ProgressReporter.new, Minitest::Reporters::DefaultReporter.new]

require 'webmock/minitest'

WebMock.disable_net_connect!(allow_localhost: true)

require 'sucker_punch/testing/inline'

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Minitest::Assertions
  include Capybara::Screenshot::MiniTestPlugin
  include Devise::Test::IntegrationHelpers

  include ApplicationHelper
  include EventsHelper

  include IntegrationSupport
  include GeocoderSupport
  include UserSupport

  # Reset sessions and driver between tests
  # Use super wherever this method is redefined in your individual test classes
  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
    Capybara.raise_server_errors = true
  end
end

class ActiveSupport::TestCase
  fixtures :all

  include TestCaseSupport
  include GeocoderSupport
  include UserSupport
end

at_exit do
  CarrierWaveTestFilesCleaner.run
end
