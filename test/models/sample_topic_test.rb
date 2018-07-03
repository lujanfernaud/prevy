# frozen_string_literal: true

require 'test_helper'

class SampleTopicTest < ActiveSupport::TestCase
  def setup
    @prevy_bot = users(:prevy_bot)
    woodell = users(:woodell)
    @group = fake_group(owner: woodell)
    @group.save
    @group.members << SampleUser.collection_for_sample_group
  end

  test "normal topics are not created by Prevy bot" do
    SampleTopic.create_topics_for_group(@group)

    @group.normal_topics.none? { |topic| topic.user == @prevy_bot }
  end

  test "there are no topic comments from topic creator" do
    SampleTopic.create_topics_for_group(@group)

    @group.normal_topics.none? do |topic|
      topic.comments.include?(topic.user.id)
    end
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

  test "increases count for UserGroupPoints" do
    group_points = UserGroupPoints.new

    UserGroupPoints.expects(:find_or_create_by!)
                   .at_least_once.returns(group_points)

    group_points.expects(:increase)
                .with(by: Topic::POINTS).at_least_once
    group_points.expects(:increase)
                .with(by: TopicComment::POINTS).at_least_once

    SampleTopic.create_topics_for_group(@group)
  end

  test "touches users after adding comments" do
    previous_updated_at = @group.members.pluck(:updated_at)

    SampleTopic.create_topics_for_group(@group)

    updated_at = @group.members.reload.pluck(:updated_at)

    assert_not_equal previous_updated_at, updated_at
  end

  test "last_commented_at date is the same as last comment's creation date" do
    SampleTopic.create_topics_for_group(@group)

    topic = @group.normal_topics.last
    last_comment_created_at = topic.comments.last.created_at

    assert_equal last_comment_created_at, topic.last_commented_at
  end

  private

    def comments_count
      @topic.comments.count
    end

    def commenters
      @topic.comments.pluck(:user_id).uniq
    end
end
