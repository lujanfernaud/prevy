require 'test_helper'

class Events::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:one)
    @phil  = users(:phil)
    @penny = users(:penny)
  end

  test "should show user" do
    sign_in(@penny)

    get event_attendee_url(@event, @phil)

    assert_response :success
  end
end
