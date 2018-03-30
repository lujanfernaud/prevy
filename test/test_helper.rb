require 'simplecov'
SimpleCov.start 'rails' unless ENV['NO_COVERAGE']

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'capybara/rails'
require 'capybara/minitest'
require 'capybara-screenshot/minitest'

require 'minitest/autorun'
require 'minitest/reporters'
require 'sucker_punch/testing/inline'
Minitest::Reporters.use! [Minitest::Reporters::ProgressReporter.new, Minitest::Reporters::DefaultReporter.new]

Capybara::Webkit.configure do |config|
  config.allow_url("gravatar.com")
  config.allow_url("api.mapbox.com")
  config.allow_url("api.tiles.mapbox.com")
end


class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Minitest::Assertions
  include Capybara::Screenshot::MiniTestPlugin

  include Devise::Test::IntegrationHelpers

  include ApplicationHelper
  include EventsHelper

  # Reset sessions and driver between tests
  # Use super wherever this method is redefined in your individual test classes
  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
    Capybara.raise_server_errors = true
  end

  def stub_geocoder
    Geocoder.configure(:lookup => :test)

    Geocoder::Lookup::Test.set_default_stub(
      [
        {
          "latitude"   => 34.997615,
          "longitude"  => 135.775637,
          "place_name" => "Place",
          "street1"    => "Matsubara-dori, 8",
          "city"       => "Kyoto",
          "post_code"  => 6050856,
          "country"    => "Japan"
        }
      ]
    )
  end

  def log_in_as(user)
    visit new_user_session_path

    fill_in "Email",    with: user.email
    fill_in "Password", with: "password"

    within "form" do
      click_on "Log in"
    end
  end

  def log_out_as(user)
    within ".navbar" do
      click_on user.name
      click_on "Log out"
    end
  end

  def select_date_and_time(date, **options)
    return nil unless date

    field = options[:from]
    select date.strftime("%Y"),  from: "#{field}_1i" # Year.
    select date.strftime("%B"),  from: "#{field}_2i" # Month.
    select date.strftime("%-d"), from: "#{field}_3i" # Day.
    select date.strftime("%H"),  from: "#{field}_4i" # Hour.
    select date.strftime("%M"),  from: "#{field}_5i" # Minutes.
  end
end

class ActiveSupport::TestCase
  fixtures :all
end
