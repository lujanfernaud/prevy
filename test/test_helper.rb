require 'simplecov'
SimpleCov.start 'rails' unless ENV['NO_COVERAGE']

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'capybara/rails'
require 'capybara/minitest'

require 'minitest/reporters'
Minitest::Reporters.use!

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Minitest::Assertions

  include ApplicationHelper
  include EventsHelper

  # Reset sessions and driver between tests
  # Use super wherever this method is redefined in your individual test classes
  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def log_in_as(user)
    visit login_path

    fill_in "Email",    with: user.email
    fill_in "Password", with: "password"

    within "form" do
      click_on "Log in"
    end
  end

  def select_date_and_time(date, **options)
    return nil unless date

    field = options[:from]
    select date.strftime("%Y"), from: "#{field}_1i" # Year.
    select date.strftime("%B"), from: "#{field}_2i" # Month.
    select date.strftime("%d"), from: "#{field}_3i" # Day.
    select date.strftime("%H"), from: "#{field}_4i" # Hour.
    select date.strftime("%M"), from: "#{field}_5i" # Minutes.
  end
end

class ActiveSupport::TestCase
  fixtures :all
end
