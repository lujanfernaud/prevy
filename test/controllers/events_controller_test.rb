require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group = groups(:one)
    @event = events(:one)
    @user  = users(:phil)
    @user.add_role :organizer, @group
  end

  test "should get index" do
    log_in_as(@user)

    get group_events_url(@group)

    assert_response :success
  end

  test "should get new" do
    log_in_as(@user)

    get new_group_event_url(@group)

    assert_response :success
  end

  test "should create event" do
    log_in_as(@user)

    assert_difference('Event.count') do
      post group_events_url(@group), params: event_params
    end

    assert_redirected_to group_event_url(@group, Event.last)
  end

  test "should show event" do
    log_in_as(@user)

    get group_event_url(@group, @event)

    assert_response :success
  end

  test "should get edit" do
    log_in_as(@user)

    get edit_group_event_url(@group, @event)

    assert_response :success
  end

  test "should update event" do
    log_in_as(@user)

    patch group_event_url(@group, @event),
      params: { event: { image: sample_image } }

    assert_redirected_to group_event_url(@group, @event)
  end

  test "should destroy event" do
    log_in_as(@user)

    assert_difference('Event.count', -1) do
      delete group_event_url(@group, @event)
    end

    assert_redirected_to group_url(@group)
  end

  private

    def log_in_as(user)
      post login_url,
        params: { session: { email: user.email, password: "password" } }
    end

    def event_params
      { event:
        {
          title: "Test event",
          description: Faker::Lorem.paragraph,
          website: "www.event.com",
          start_date: Time.zone.now + 6.days,
          end_date: Time.zone.now + 1.week,
          image: sample_image
        }
      }
    end

    def sample_image
      fixture_file_upload("test/fixtures/files/sample.jpeg", "image/jpeg")
    end
end
