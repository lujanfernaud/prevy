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
end
