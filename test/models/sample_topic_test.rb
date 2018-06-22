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

  test "updates user topic_comments_count" do
    SampleTopic.create_topics_for_group(@group)

    @group.members.each do |member|
      assert_not member.group_comments_count(@group).number.zero?
    end
  end

  test "touches users after adding comments" do
    previous_updated_at = @group.members.pluck(:updated_at)

    SampleTopic.create_topics_for_group(@group)

    updated_at = @group.members.reload.pluck(:updated_at)

    assert_not_equal previous_updated_at, updated_at
  end
end
