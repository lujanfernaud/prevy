# frozen_string_literal: true

require 'test_helper'

class Events::AttendeesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:one)
    @phil  = users(:phil)
    @penny = users(:penny)
  end

  test "should get index" do
    sign_in(@penny)

    get event_attendees_url(@event)

    assert_response :success
  end

  test "should show user" do
    sign_in(@penny)

    get event_attendee_url(@event, @phil)

    assert_response :success
  end
end
