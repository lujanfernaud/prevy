# frozen_string_literal: true

require 'test_helper'

class TopicsIndexTest < ActionDispatch::IntegrationTest
  include TopicsIntegrationSupport

  def setup
    @topic = topics(:one)
    @group = groups(:one)
    @phil  = users(:phil)
  end

  test "user visits index" do
    log_in_as @phil

    visit group_topics_path(@group)

    assert_breadcrumbs
    assert_topics(@group)
    assert_pagination

    click_on "Submit a new topic"

    assert_equal current_path, new_group_topic_path(@group)
  end

  test "topic row shows 'opened' and topic author" do
    topic = fake_topic(user: @phil)
    topic.save

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
    topic.save

    comment = fake_comment(user: woodell, topic: topic)
    comment.save

    log_in_as @phil

    visit group_topics_path(@group)

    within "#topic-#{topic.id}" do
      assert page.has_content? "Last commented"
      assert page.has_content? "by Woodell"
    end
  end

  private

    def assert_breadcrumbs
      within ".breadcrumb" do
        assert page.has_link?    @group.name
        assert page.has_content? "Topics"
      end
    end
end
