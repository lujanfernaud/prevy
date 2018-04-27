require 'test_helper'

class UserEventsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    user = users(:phil)

    sign_in(user)

    get user_events_url(user)
    assert_response :success
  end
end
