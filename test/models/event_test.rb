# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id              :bigint(8)        not null, primary key
#  attendees_count :integer          default(0), not null
#  description     :string
#  end_date        :datetime
#  image           :string
#  sample_event    :boolean          default(FALSE)
#  slug            :string
#  start_date      :datetime
#  title           :string
#  updated_fields  :jsonb            not null
#  website         :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  group_id        :bigint(8)
#  organizer_id    :bigint(8)
#
# Indexes
#
#  index_events_on_group_id      (group_id)
#  index_events_on_organizer_id  (organizer_id)
#  index_events_on_slug          (slug)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def setup
    stub_geocoder
    stub_requests_to_googleapis
    stub_sample_content_for_new_users
  end

  test "is valid" do
    event = fake_event

    assert event.valid?
  end

  test "is invalid without title" do
    event = fake_event(title: "")

    refute event.valid?
  end

  test "is invalid with short title" do
    event = fake_event(title: "Eve")

    refute event.valid?
  end

  test "is invalid without description" do
    event = fake_event(description: "")

    refute event.valid?
  end

  test "is invalid with short description" do
    event = fake_event(description: "An event")

    refute event.valid?
  end

  test "is invalid without image" do
    event = fake_event(image: "")

    refute event.valid?
  end

  test "is invalid with a start date that has already passed" do
    event = fake_event(start_date: 1.day.ago)

    refute event.valid?
  end

  test "is invalid with an end date that has already passed" do
    event = fake_event(end_date: 1.day.ago)

    refute event.valid?
  end

  test "is invalid without a street" do
    event = fake_event(street1: "")

    refute event.valid?
  end

  test "is invalid without a city" do
    event = fake_event(city: "")

    refute event.valid?
  end

  test "is invalid without a post code" do
    event = fake_event(post_code: "")

    refute event.valid?
  end

  test "is invalid without a country" do
    event = fake_event(country: "")

    refute event.valid?
  end

  test "titleizes event title before saving" do
    event = fake_event(title: "john's event")

    event.save!

    assert_equal "John's Event", event.title
  end

  test "adds protocol to event's website before saving if missing" do
    WebsiteUrlFormatter.expects(:call)

    create :event, website: "www.eventwebsite.com"
  end

  test "delegates address methods" do
    event = fake_event

    assert event.place_name
    assert event.street1
    assert event.street2
    assert event.city
    assert event.state
    assert event.post_code
    assert event.country
    assert event.full_address
  end

  test "#group" do
    event = events(:one)
    group = groups(:one)

    assert_equal event.group, group
  end

  test "stores updated fields" do
    event = fake_event
    event.save!

    assert event.updated_fields.empty?

    event.start_date = 1.month.from_now
    event.end_date   = 1.month.from_now + 1.hour
    event.save!

    assert event.updated_fields.include?("updated_start_date")
    assert event.updated_fields.include?("updated_end_date")
    refute event.updated_fields.include?("updated_address")

    event.address.city = "Santa Cruz de Tenerife"
    event.save!

    refute event.updated_fields.include?("updated_start_date")
    refute event.updated_fields.include?("updated_end_date")
    assert event.updated_fields.include?("updated_address")
  end

  test "touches group after saving" do
    event = fake_event
    group = event.group

    group_original_updated_at = group.updated_at

    event.save!

    refute_equal group_original_updated_at, group.reload.updated_at
  end

  test "creates event's topic" do
    event = fake_event
    event.save!

    assert event.topic
  end

  test "updates event's topic" do
    event = fake_event
    event.save!

    topic = event.topic
    original_topic_title = topic.title
    original_topic_body  = topic.body

    event.update_attributes(
      title: "New title",
      description: "New description" * 9
    )

    refute_equal original_topic_title, event.topic.title
    refute_equal original_topic_body, event.topic.body
    assert_equal topic.title, event.title
    assert_equal topic.body, event.description
  end

  test "has title as slug" do
    event = fake_event
    title_parameterized = event.title.parameterize

    event.save!

    assert_equal title_parameterized, event.slug
  end

  test "slug candidates work" do
    event_one = create :event, title: "Test Event"
    event_two = create :event, title: "Test Event"

    assert_equal "test-event", event_one.slug
    assert_equal "test-event-#{start_date(event_two)}", event_two.slug
  end

  test "#comments" do
    event = fake_event
    event.save!

    assert event.comments
  end

  test "#recent_attendees" do
    event = create :event
    limit = Event::RECENT_ATTENDEES

    RecentAttendeesQuery.expects(:call).with(event, limit)

    event.recent_attendees
  end

  test "#random_attendees" do
    event = create :event
    limit = Event::RANDOM_ATTENDEES

    RandomAttendeesQuery.expects(:call).with(event, limit)

    event.random_attendees
  end

  private

    def start_date(event)
      event.start_date.strftime("%b %d %Y").parameterize
    end
end
