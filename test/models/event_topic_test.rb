require 'test_helper'

class EventTopicTest < ActiveSupport::TestCase
  def setup
    stub_requests_to_googleapis
  end

  test "has priority" do
    event = fake_event
    event.save

    assert_equal 1, event.topic.priority
  end

  test "touches event when adding a comment" do
    topic = event_topics(:event_topic_one)
    event = events(:one)
    event.update_attributes(title: "Test event")
    event.update_attributes(updated_at: 1.day.ago)

    assert_in_delta 1.day.ago, event.reload.updated_at, 1.minute

    topic.comments.create!(user: SampleUser.all.sample, body: "Test comment")

    assert_in_delta topic.reload.updated_at, event.reload.updated_at, 1.minute
  end
end
