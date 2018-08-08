# frozen_string_literal: true

require 'test_helper'

class CommentsEditTest < ActionDispatch::IntegrationTest
  include TopicsIntegrationSupport
  include CommentsIntegrationSupport

  def setup
    @group   = groups(:one)
    @phil    = users(:phil)
    @topic   = topics(:one)
    @comment = topic_comments(:one)

    prepare_javascript_driver
  end

  test "moderator can edit comment" do
    @group.add_to_moderators(@phil)
    comment = @topic.comments.where.not(user: @phil).first

    log_in_as @phil

    visit group_topic_path(@group, @topic)

    within "#comment-#{comment.id}" do
      assert page.has_link? "Edit"
    end
  end

  test "author can edit comment" do
    comment = @topic.comments.where.not(user: @phil).first
    author  = comment.user

    log_in_as author

    visit group_topic_path(@group, @topic)

    within "#comment-#{comment.id}" do
      assert page.has_link? "Edit"
    end
  end

  test "user other than moderator or author can't edit comment" do
    stub_sample_content_for_new_users

    comment = @topic.comments.where.not(user: @phil).first
    user    = create :user, :confirmed
    @group.members << user

    log_in_as user

    visit group_topic_path(@group, @topic)

    within "#comment-#{comment.id}" do
      assert_not page.has_link? "Edit"
    end
  end

  test "caching doesn't keep 'edit' link" do
    stub_sample_content_for_new_users

    @group.add_to_moderators(@phil)

    comment = @topic.comments.where.not(user: @phil).first
    user    = create :user, :confirmed
    @group.members << user

    log_in_as @phil

    visit group_topic_path(@group, @topic)

    within "#comment-#{comment.id}" do
      assert page.has_link? "Edit"
    end

    log_out

    log_in_as user

    visit group_topic_path(@group, @topic)

    within "#comment-#{comment.id}" do
      assert_not page.has_link? "Edit"
    end
  end

  test "user visits 'comments/edit'" do
    log_in_as @phil

    visit edit_comment_path(@comment)

    assert_breadcrumbs
    assert page.has_link? "Delete comment"
  end

  test "breadcrumbs appear when there is an error in the submission" do
    log_in_as @phil

    visit edit_comment_path(@comment)

    fill_in_body_with ""

    click_on "Update comment"

    assert page.has_content? "error"
    assert_breadcrumbs
  end

  test "clicking on event topic breadcrums takes you to the event" do
    stub_sample_content_for_new_users

    event = create :event
    group = event.group
    topic = event.topic
    comment = create :topic_comment, topic: topic

    log_in_as group.owner

    visit edit_comment_path(comment)

    within ".breadcrumb" do
      click_on event.title
    end

    # save_and_open_page

    assert_current_path group_event_path(group, event)
  end

  private

    def assert_breadcrumbs
      within ".breadcrumb" do
        assert page.has_link?    @group.name
        assert page.has_link?    "Topics"
        assert page.has_link?    @topic.title
        assert page.has_content? "Edit comment"
      end
    end
end
