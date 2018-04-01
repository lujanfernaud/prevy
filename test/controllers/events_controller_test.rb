require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group = groups(:one)
    @event = events(:one)
    @user  = users(:phil)
    @user.add_role :organizer, @group
  end

  test "should get index for groups" do
    sign_in(@user)

    get group_events_url(@group)

    assert_response :success
  end

  test "should get index for users" do
    sign_in(@user)

    get user_events_url(@group)

    assert_response :success
  end

  test "should get new" do
    sign_in(@user)

    get new_group_event_url(@group)

    assert_response :success
  end

  test "should create event" do
    sign_in(@user)

    assert_difference('Event.count') do
      post group_events_url(@group), params: event_params
    end

    assert_redirected_to group_event_url(@group, Event.last)
  end

  test "should show event" do
    sign_in(@user)

    get group_event_url(@group, @event)

    assert_response :success
  end

  test "should get edit" do
    sign_in(@user)

    get edit_group_event_url(@group, @event)

    assert_response :success
  end

  test "should update event" do
    sign_in(@user)

    patch group_event_url(@group, @event),
      params: { event: { image: sample_image } }

    assert_redirected_to group_event_url(@group, @event)
  end

  test "should destroy event" do
    sign_in(@user)

    assert_difference('Event.count', -1) do
      delete group_event_url(@group, @event)
    end

    assert_redirected_to group_url(@group)
  end

  private

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
