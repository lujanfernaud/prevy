require 'test_helper'

class TopicsShowTest < ActionDispatch::IntegrationTest
  include TopicsIntegrationSupport

  def setup
    @group = groups(:one)
    @phil  = users(:phil)
    @topic = topics(:one)
  end

  test "user visits topic" do
    log_in_as @phil

    visit group_topic_path(@group, @topic)

    assert_breadcrumbs
    assert_topic_content
    assert_all_comments_are_shown
    assert_new_comment_form
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
      assert page.has_link?    @topic.user.name
      assert page.has_content? @topic.title
      assert page.has_content? @topic.body
    end

    def assert_all_comments_are_shown
      assert page.has_css? ".comment-container", count: @topic.comments.count
    end

    def assert_new_comment_form
      assert page.has_css? "form#new_topic_comment"
    end
end
