# frozen_string_literal: true

require 'test_helper'

class SampleCommentsCreatorTest < ActiveSupport::TestCase
  MIN_COMMENTS   =  MIN_COMMENTS
  MAX_COMMENTS   =  MAX_COMMENTS
  COMMENTS_RANGE = (MIN_COMMENTS..MAX_COMMENTS)

  def setup
    stub_sample_content_for_new_users

    @users = SampleUser.collection_for_sample_group
    @group = create :group
    @group.members << @users
  end

  test "there are no topic comments from topic creator" do
    create_list :topic, 6, group: @group

    SampleCommentsCreator.call(@group)

    @group.topics.each do |topic|
      assert_not topic.comments.include?(topic.user.id)
    end
  end

  test "every comment is from a different user" do
    SampleCommentsCreator.call(@group)

    @group.topics.each do |topic|
      user_ids = topic.comments.pluck(:user_id)

      assert_equal user_ids, user_ids.uniq
    end
  end

  test "all topics have comments in range" do
    create_list :topic, 6, group: @group

    SampleCommentsCreator.call(@group)

    @group.topics.each do |topic|
      assert topic.comments.size.in? COMMENTS_RANGE
    end
  end

  test "doesn't add comments to event topic" do
    event = create :event, group: @group, organizer: @group.owner
    event.attendees << users

    create_list :topic, 6, group: @group

    SampleCommentsCreator.call(@group)

    assert_equal 0, event.topic.comments.size
  end

  test "increases count for UserGroupPoints" do
    create_list :topic, 6, group: @group

    group_points = UserGroupPoints.new

    UserGroupPoints.expects(:find_or_create_by!)
                   .at_least_once.returns(group_points)

    group_points.expects(:increase)
                .with(by: TopicComment::POINTS).at_least_once

    SampleCommentsCreator.call(@group)
  end

  test "topics last_commented_at date is last comment's created_at date" do
    create_list :topic, 6, group: @group

    SampleCommentsCreator.call(@group)

    @group.topics.all? do |topic|
      assert_equal topic.comments.last.created_at, topic.last_commented_at
    end
  end

  test "topics comments_count is updated" do
    create_list :topic, 6, group: @group

    SampleCommentsCreator.call(@group)

    @group.topics.each do |topic|
      assert_equal topic.comments.size, topic.reload.comments_count
    end
  end
end
