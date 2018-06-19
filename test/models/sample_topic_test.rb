require 'test_helper'

class SampleTopicTest < ActiveSupport::TestCase
  def setup
    woodell = users(:woodell)
    @group = fake_group(owner: woodell)
    @group.save
    @group.members << SampleUser.select_random(5)
  end

  test "creates normal topics with comments" do
    SampleTopic.create_topics_for_group(@group)

    topic = @group.normal_topics.last

    assert_equal 6, @group.normal_topics.count
    assert topic.comments.count > 4
  end

  test "creates announcement topic with comments" do
    SampleTopic.create_topics_for_group(@group)

    topic = @group.announcement_topics.last

    assert_equal 1, @group.announcement_topics.count
    assert topic.comments.count > 4
  end

  test "creates pinned topic with comments" do
    SampleTopic.create_topics_for_group(@group)

    topic = @group.pinned_topics.last

    assert_equal 1, @group.pinned_topics.count
    assert topic.comments.count > 4
  end
end
