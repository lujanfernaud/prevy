# frozen_string_literal: true

require 'test_helper'

class TopicsIndexTest < ActionDispatch::IntegrationTest
  include TopicsIntegrationSupport

  def setup
    @topic = topics(:one)
    @group = groups(:one)
    @phil  = users(:phil)

    stub_sample_content_for_new_users
  end

  test "user visits index" do
    topics_per_page = Topic::TOPICS_PER_PAGE

    group = create :group
    create_list :topic, topics_per_page + 5, group: group

    log_in_as group.owner

    visit group_topics_path(group)

    assert_breadcrumbs_for(group)
    assert_topics(group)
    assert_pagination

    click_on "Submit a new topic"

    assert_equal current_path, new_group_topic_path(group)
  end

  test "logged out user visits index" do
    topic = create :topic
    group = topic.group

    visit group_topics_path(group)

    assert_current_path new_user_session_path
  end

  test "logged in user visits index" do
    user  = create :user
    topic = create :topic
    group = topic.group

    log_in_as user

    visit group_topics_path(group)

    assert_current_path root_path
  end

  test "logged out invited user visits index" do
    topic = create :topic
    group = topic.group

    invitation = create :group_invitation,
                         group:  group,
                         sender: group.owner,
                         email:  "test@test.test"

    visit group_path(group, token: invitation.token)
    visit group_topics_path(group)

    assert_current_path group_topics_path(group)
  end

  test "logged in invited user visits index" do
    user  = create :user
    topic = create :topic
    group = topic.group

    invitation = create :group_invitation,
                         group:  group,
                         sender: group.owner,
                         email:  user.email

    log_in_as user

    visit group_path(group, token: invitation.token)
    visit group_topics_path(group)

    assert_current_path group_topics_path(group)
  end

  test "topic row shows 'opened' and topic author" do
    topic = fake_topic(user: @phil)
    topic.save!

    log_in_as @phil

    visit group_topics_path(@group)

    within "#topic-#{topic.id}" do
      assert page.has_content? "Opened"
      assert page.has_content? "by Phil"
    end
  end

  test "topic row shows 'last commented' and comment author" do
    woodell = users(:woodell)
    @group.members << woodell

    topic = fake_topic(user: @phil)
    topic.save!

    comment = fake_comment(user: woodell, topic: topic)
    comment.save!

    log_in_as @phil

    visit group_topics_path(@group)

    within "#topic-#{topic.id}" do
      assert page.has_content? "Last commented"
      assert page.has_content? "by Woodell"
    end
  end

  private

    def assert_breadcrumbs_for(group)
      within ".breadcrumb" do
        assert page.has_link?    group.name
        assert page.has_content? "Topics"
      end
    end
end
