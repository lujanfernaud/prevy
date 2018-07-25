# frozen_string_literal: true

require 'simplecov'
SimpleCov.start 'rails' unless ENV['NO_COVERAGE']

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/minitest'
require 'support/support'

require 'database_cleaner'

DatabaseCleaner.clean_with :truncation
DatabaseCleaner.strategy = :transaction

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

Minitest::Reporters.use! [
  Minitest::Reporters::DefaultReporter.new(color: true, slow_count: 5)
]

require 'webmock/minitest'

WebMock.disable_net_connect!(allow_localhost: true)

require 'sucker_punch/testing/inline'

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Minitest::Assertions
  include Capybara::Screenshot::MiniTestPlugin
  include Devise::Test::IntegrationHelpers
  include FactoryBot::Syntax::Methods

  include DatabaseCleanerSupport

  include ApplicationHelper

  include StubsSupport
  include IntegrationSupport
  include UserSupport

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
    Capybara.raise_server_errors = true
  end
end

class ActiveSupport::TestCase
  fixtures :all
  include FactoryBot::Syntax::Methods

  include DatabaseCleanerSupport

  include StubsSupport
  include TestCaseSupport
  include UserSupport
end

at_exit do
  CarrierWaveTestFilesCleaner.run
end
