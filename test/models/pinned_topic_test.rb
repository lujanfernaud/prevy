require 'test_helper'

class PinnedTopicTest < ActiveSupport::TestCase
  test "has priority" do
    topic = fake_topic(type: "PinnedTopic")
    topic.save

    assert_equal PinnedTopic::PRIORITY, topic.priority
  end

  test "priority changes to 0 when updating type to 'Topic'" do
    topic = fake_topic(type: "PinnedTopic")
    topic.save

    topic.update_attributes(type: "Topic")

    topic = Topic.last

    assert_equal Topic::PRIORITY, topic.priority
  end

  test "keeps it as pinned topic on update" do
    topic = fake_topic(type: "PinnedTopic")
    topic.save

    topic.update_attributes(title: "Pinned topic updated")

    topic = Topic.last

    assert_equal "PinnedTopic", topic.type
    assert_equal PinnedTopic::PRIORITY, topic.priority
  end

end
