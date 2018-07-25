# frozen_string_literal: true

require 'test_helper'

class EventDecoratorTest < ActiveSupport::TestCase
  def setup
    stub_requests_to_googleapis
    stub_sample_content_for_new_users
  end

  test "#organizer? is true" do
    event = fake_event_decorator

    assert event.organizer? event.organizer
  end

  test "#organizer? is false" do
    event = fake_event_decorator
    user  = create :user

    assert_not event.organizer? user
  end

  test "#not_an_attendee? is true" do
    event = fake_event_decorator
    user  = create :user

    assert event.not_an_attendee? user
  end

  test "#not_an_attendee? is false" do
    event = fake_event_decorator
    user  = create :user
    event.attendees << user

    assert_not event.not_an_attendee? user
  end

  test "#has_more_attendees_than_recent_attendees? is true" do
    event = fake_event_decorator
    event.stubs(:attendees_count).returns(Event::RECENT_ATTENDEES + 1)

    assert event.has_more_attendees_than_recent_attendees?
  end

  test "#has_more_attendees_than_recent_attendees? is false" do
    event = fake_event_decorator
    event.stubs(:attendees_count).returns(1)

    assert_not event.has_more_attendees_than_recent_attendees?
  end

  test "#full_address returns full address without country" do
    event = fake_event_decorator
    full_address = "Obento, Matsubara-dori, 8, Kyoto, 6050856"

    assert_equal event.full_address, full_address
  end

  test "#short_address returns place name and city" do
    event = fake_event_decorator
    short_address = "Obento, Kyoto"

    assert_equal event.short_address, short_address
  end

  test "#start_date_prettyfied for this year doesn't include year" do
    event = fake_event_decorator(
      start_date: 1.week.from_now,
      end_date:   1.week.from_now
    )

    assert(
      event.start_date.strftime("%A, %b. %d, %H:%M"),
      event.start_date_prettyfied
    )
  end

  test "#start_date_prettyfied for next year includes year" do
    event = fake_event_decorator(
      start_date: 1.week.from_now,
      end_date:   1.week.from_now
    )

    assert(
      event.start_date.strftime("%A, %b. %d, %Y, %H:%M"),
      event.start_date_prettyfied
    )
  end

  test "#end_date_prettyfied for this year doesn't include year" do
    event = fake_event_decorator(
      start_date: 1.week.from_now,
      end_date:   1.week.from_now
    )

    assert(
      event.end_date.strftime("%A, %b. %d, %H:%M"),
      event.end_date_prettyfied
    )
  end

  test "#end_date_prettyfied for next year includes year" do
    event = fake_event_decorator(
      start_date: 1.week.from_now,
      end_date:   1.week.from_now
    )

    assert(
      event.end_date.strftime("%A, %b. %d, %Y, %H:%M"),
      event.end_date_prettyfied
    )
  end

  test "#same_time?" do
    event = fake_event_decorator(
      start_date: 1.week.from_now,
      end_date:   1.week.from_now
    )

    assert event.same_time?
  end

  test "#website_prettyfied" do
    event = fake_event_decorator(website: "https://www.testwebsite.com")
    expected = "www.testwebsite.com"

    assert_equal expected, event.website_prettyfied
  end

  test "#attendees_title_with_count" do
    event = fake_event_decorator
    event.stubs(:attendees_count).returns(1)

    assert "Attendees (0)", event.attendees_title_with_count

    event.stubs(:attendees_count).returns(9)

    assert "Attendees (9)", event.attendees_title_with_count
  end

  private

    def fake_event_decorator(params = {})
      @fake_event_decorator ||= EventDecorator.new(fake_event(params))
    end
end
