# frozen_string_literal: true

require 'test_helper'

class SampleTopicCreatorTest < ActiveSupport::TestCase
  NORMAL_TOPICS_COUNT = SampleTopicCreator::NORMAL_TOPICS

  def setup
    stub_sample_content_for_new_users

    @prevy_bot = users(:prevy_bot)
    @group     = create :group
    @group.members << SampleUser.collection_for_sample_group
  end

  test "normal topics are not created by Prevy bot" do
    SampleTopicCreator.call(@group)

    @group.normal_topics.each do |topic|
      assert_not topic.user == @prevy_bot
    end
  end

  test "creates normal topics" do
    SampleTopicCreator.call(@group)

    assert_equal NORMAL_TOPICS_COUNT, @group.normal_topics.size
  end

  test "creates announcement topic" do
    SampleTopicCreator.call(@group)

    assert_equal 1, @group.announcement_topics.size
    assert_equal @prevy_bot, @group.announcement_topics.first.user
  end

  test "creates pinned topic" do
    SampleTopicCreator.call(@group)

    assert_equal 1, @group.pinned_topics.size
    assert_equal @prevy_bot, @group.pinned_topics.first.user
  end

  test "increases count for UserGroupPoints" do
    group_points = UserGroupPoints.new

    UserGroupPoints.expects(:find_or_create_by!)
                   .at_least_once.returns(group_points)

    group_points.expects(:increase)
                .with(by: Topic::POINTS).at_least_once
    group_points.expects(:increase)
                .with(by: TopicComment::POINTS).at_least_once

    SampleTopicCreator.call(@group)
  end

  test "updates group topics_count" do
    SampleTopicCreator.call(@group)

    assert_equal @group.topics.size, @group.reload.topics_count
  end

  test "creates sample comments" do
    SampleCommentsCreator.expects(:call)

    SampleTopicCreator.call(@group)
  end

  private

    def commenters
      @topic.comments.pluck(:user_id).uniq
    end
end
