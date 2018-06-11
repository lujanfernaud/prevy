require 'test_helper'

class SampleTopicTest < ActiveSupport::TestCase
  def setup
    @group = groups(:one)
    @group.topics.destroy
  end

  test "creates normal topics with comments" do
    SampleTopic.create_topics_for_group(@group)

    topic = @group.topics.last

    assert topic.normal?
    assert topic.comments.count > 5
  end

  test "creates announcement topic with comments" do
    SampleTopic.create_announcement_topic_for_group(@group)

    topic = @group.topics.last

    assert_equal @group.owner, topic.user
    assert topic.announcement?
    assert topic.comments.count > 5
  end
end
