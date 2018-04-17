require 'simplecov'
SimpleCov.start 'rails' unless ENV['NO_COVERAGE']

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'capybara/rails'
require 'capybara/minitest'
require 'capybara-screenshot/minitest'
Capybara.match = :prefer_exact

require 'minitest/autorun'
require 'minitest/reporters'

require 'webmock/minitest'
WebMock.disable_net_connect!(allow_localhost: true)

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

  def fill_in_description(description)
    find("trix-editor").click.set(description)
  end

  def attach_valid_image_for(field)
    attach_file field, "test/fixtures/files/sample.jpeg"
  end

  def upload_valid_image
    fixture_file_upload("test/fixtures/files/sample.jpeg", "image/jpeg")
  end

  # We need to do this because Rolify doesn't seem to work very well with
  # fixtures for scoped roles.
  def add_group_owner_to_organizers(group)
    group.owner.add_role(:organizer, group)
  end

  def add_members_to_group(group, *users)
    users.each { |user| user.add_role(:member, group) }
  end
end

class ActiveSupport::TestCase
  fixtures :all

  def stub_requests_to_googleapis
    WebMock.stub_request(:get, /maps.googleapis.com/)
           .to_return(status: 200, body: "", headers: {})
  end

  def fake_event(params = {})
    Event.new(
      group:       params[:group]       || groups(:two),
      title:       params[:title]       || "Test event",
      description: params[:description] || Faker::Lorem.paragraph,
      website:     params[:website]     || "",
      start_date:  params[:start_date]  || 6.days.from_now,
      end_date:    params[:end_date]    || 1.week.from_now,
      image:       params[:image]       || valid_image,
      organizer:   params[:user]        || users(:phil),
      address_attributes: address(params)
    )
  end

  def address(params = {})
    {
      place_name: params[:place_name] || "Obento",
      street1:    params[:street1]    || "Matsubara-dori, 8",
      street2:    params[:street2]    || "",
      city:       params[:city]       || "Kyoto",
      state:      params[:state]      || "",
      post_code:  params[:post_code]  || "6050856",
      country:    params[:country]    || "Japan"
    }
  end

  def valid_image
    File.open(Rails.root.join("test/fixtures/files/sample.jpeg"))
  end
end
