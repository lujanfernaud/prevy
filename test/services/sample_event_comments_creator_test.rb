# frozen_string_literal: true

require 'test_helper'

class SampleEventCommentsCreatorTest < ActiveSupport::TestCase
  COMMENTS_COUNT = SampleEventCommentsCreator::COMMENTS_COUNT

  def setup
    stub_sample_content_for_new_users

    @users = SampleUser.collection_for_sample_group
    @event = create :event
    @event.attendees << @users
  end

  test "there are no comments from event organizer" do
    SampleEventCommentsCreator.call(@event)

    assert_not @event.comments.include?(@event.organizer.id)
  end

  test "every comment is from a different user" do
    SampleEventCommentsCreator.call(@event)

    event_topic = @event.topic

    user_ids = event_topic.comments.pluck(:user_id)

    assert_equal user_ids, user_ids.uniq
  end

  test "has all comments from seeds" do
    SampleEventCommentsCreator.call(@event)

    assert_equal COMMENTS_COUNT, @event.comments.size
  end

  test "increases count for UserGroupPoints" do
    group_points = UserGroupPoints.new

    UserGroupPoints.expects(:find_or_create_by!)
                   .at_least_once.returns(group_points)

    group_points.expects(:increase)
                .with(by: TopicComment::POINTS).at_least_once

    SampleEventCommentsCreator.call(@event)
  end

  test "event topic last_commented_at date is last comment's creation date" do
    SampleEventCommentsCreator.call(@event)

    event_topic  = @event.topic
    last_comment = event_topic.comments.last

    assert_equal last_comment.created_at, event_topic.last_commented_at
  end

  test "topics comments_count is updated" do
    SampleEventCommentsCreator.call(@event)

    event_topic = @event.topic

    assert_equal event_topic.comments.size, event_topic.reload.comments_count
  end
end
