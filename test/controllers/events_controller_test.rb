# frozen_string_literal: true

require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    stub_geocoder

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

    assert_emails_sent_to @group.members
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
    stub_sample_content_for_new_users

    users = create_list :user, 10, :confirmed
    group = create :group
    group.members << users

    event = create :event, group: group, organizer: group.owner
    event.attendees << users

    sign_in(group.owner)

    ActionMailer::Base.deliveries.clear

    patch group_event_url(group, event), params: event_params_updated

    assert_emails_sent_to event.attendees
    assert_redirected_to group_event_url(group, event)
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
          title:       "Test event",
          description: Faker::Lorem.paragraph,
          website:     "www.event.com",
          start_date:  Time.zone.now + 6.days,
          end_date:    Time.zone.now + 1.week,
          image:       upload_valid_image
        }
      }
    end

    def event_params_updated
      { event:
        {
          start_date: 1.week.from_now,
          end_date:   1.week.from_now + 1.hour,
          image:      upload_valid_image
        }
      }
    end

    def assert_emails_sent_to(users)
      assert_equal users.map(&:email), sent_to_emails
    end

    def sent_to_emails
      ActionMailer::Base.deliveries.map(&:to).flatten
    end
end
