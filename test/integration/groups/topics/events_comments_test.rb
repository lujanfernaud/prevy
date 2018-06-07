require 'test_helper'

class EventsCommentsTest < ActionDispatch::IntegrationTest
  include TopicsIntegrationSupport
  include CommentsIntegrationSupport

  def setup
    @phil  = users(:phil)
    @group = groups(:one)
    @event = events(:one)
    @topic = @event.topic

    prepare_javascript_driver
  end

  test "user is redirected back to the event after creating a comment" do
    log_in_as @phil

    visit group_event_path(@group, @event)

    submit_new_comment_with "This is great!"

    assert_equal group_event_path(@group, @event), current_path
  end

  test "user is redirected back to the event after editing a comment" do
    comment = @event.comments.last

    log_in_as @phil

    visit group_event_path(@group, @event)

    click_on_edit_comment(comment)

    update_comment_with "Revised comment."

    assert_equal group_event_path(@group, @event), current_path
  end

  test "user is redirected back to the event after deleting a comment" do
    comment = @event.comments.last

    log_in_as @phil

    visit group_event_path(@group, @event)

    click_on_edit_comment(comment)

    click_on "Delete comment"

    assert_equal group_event_path(@group, @event), current_path
  end

  test "user is redirected back to the topic after creating a comment" do
    log_in_as @phil

    visit group_topic_path(@group, @topic)

    submit_new_comment_with "This is great!"

    assert_equal group_topic_path(@group, @topic), current_path
  end

  test "user is redirected back to the topic after editing a comment" do
    comment = @event.comments.last

    log_in_as @phil

    visit group_topic_path(@group, @topic)

    click_on_edit_comment(comment)

    update_comment_with "Revised comment."

    assert_equal group_topic_path(@group, @topic), current_path
  end

  test "user is redirected back to the topic after deleting a comment" do
    comment = @event.comments.last

    log_in_as @phil

    visit group_topic_path(@group, @topic)

    click_on_edit_comment(comment)

    click_on "Delete comment"

    assert_equal group_topic_path(@group, @topic), current_path
  end
end
