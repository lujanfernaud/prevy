# frozen_string_literal: true

require 'test_helper'

class TopicsShowTest < ActionDispatch::IntegrationTest
  include TopicsIntegrationSupport

  def setup
    @group = groups(:one)
    @phil  = users(:phil)
    @topic = topics(:one)

    stub_sample_content_for_new_users
  end

  test "user visits topic" do
    log_in_as @phil

    visit group_topic_path(@group, @topic)

    assert_breadcrumbs
    assert_topic_content
    assert_all_comments_are_shown
    assert_new_comment_form
  end

  test "user visits event topic" do
    topic = event_topics(:event_topic_one)

    log_in_as @phil

    visit group_topic_path(@group, topic)

    within ".topic-container" do
      click_on "See event"
    end

    assert_equal group_event_path(@group, topic.event), current_path
  end

  test "logged out user visits topic" do
    topic = create :topic
    group = topic.group

    visit group_topic_path(group, topic)

    assert_current_path new_user_session_path
  end

  test "logged in user visits topic" do
    user  = create :user
    topic = create :topic
    group = topic.group

    log_in_as user

    visit group_topic_path(group, topic)

    assert_current_path root_path
  end

  test "logged out invited user visits topic" do
    topic = create :topic
    group = topic.group

    invitation = create :group_invitation,
                         group:  group,
                         sender: group.owner,
                         email:  "test@test.test"

    visit group_path(group, token: invitation.token)
    visit group_topic_path(group, topic)

    assert_current_path group_topic_path(group, topic)
  end

  test "logged in invited user visits topic" do
    user  = create :user
    topic = create :topic
    group = topic.group

    invitation = create :group_invitation,
                         group:  group,
                         sender: group.owner,
                         email:  user.email

    log_in_as user

    visit group_path(group, token: invitation.token)
    visit group_topic_path(group, topic)

    assert_current_path group_topic_path(group, topic)
  end

  private

    def assert_breadcrumbs
      within ".breadcrumb" do
        assert page.has_link?    @group.name
        assert page.has_link?    "Topics"
        assert page.has_content? @topic.title
      end
    end

    def assert_topic_content
      assert page.has_content? @topic.title

      within "#topic-#{@topic.id}" do
        assert page.has_link?    @topic.user.name
        assert page.has_content? @topic.body
        assert page.has_content? user_points(@group, @topic.user)
        assert page.has_content? @topic.body
      end
    end

    def assert_all_comments_are_shown
      assert page.has_css? ".comment-container", count: @topic.comments.size
    end

    def assert_new_comment_form
      assert page.has_css? "form#new_topic_comment"
    end
end
