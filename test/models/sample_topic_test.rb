require 'test_helper'

class SampleTopicTest < ActiveSupport::TestCase
  def setup
    @prevy_bot = users(:prevy_bot)
    woodell = users(:woodell)
    @group = fake_group(owner: woodell)
    @group.save
    @group.members << SampleUser.collection_for_sample_group
  end

  test "creates normal topics with comments" do
    SampleTopic.create_topics_for_group(@group)

    @topic = @group.normal_topics.last

    assert_equal 6, @group.normal_topics.count
    assert comments_count > 4
    assert_equal comments_count, commenters.count
  end

  test "creates announcement topic with comments" do
    SampleTopic.create_topics_for_group(@group)

    @topic = @group.announcement_topics.last

    assert_equal 1, @group.announcement_topics.count
    assert_equal @prevy_bot, @group.announcement_topics.first.user
    assert comments_count > 4
    assert_equal comments_count, commenters.count
  end

  test "creates pinned topic with comments" do
    SampleTopic.create_topics_for_group(@group)

    @topic = @group.pinned_topics.last

    assert_equal 1, @group.pinned_topics.count
    assert_equal @prevy_bot, @group.pinned_topics.first.user
    assert comments_count > 4
    assert_equal comments_count, commenters.count
  end

  test "updates user topic_comments_count" do
    SampleTopic.create_topics_for_group(@group)

    assert_not all_members_have_a_zero_comments_count?
  end

  test "touches users after adding comments" do
    previous_updated_at = @group.members.pluck(:updated_at)

    SampleTopic.create_topics_for_group(@group)

    updated_at = @group.members.reload.pluck(:updated_at)

    assert_not_equal previous_updated_at, updated_at
  end

  private

    def comments_count
      @topic.comments.count
    end

    def commenters
      @topic.comments.pluck(:user_id).uniq
    end

    def all_members_have_a_zero_comments_count?
      @group.members.all? { |m| m.group_comments_count(@group).number.zero? }
    end
end
