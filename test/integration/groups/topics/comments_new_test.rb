# frozen_string_literal: true

require 'test_helper'

class CommentsNewTest < ActionDispatch::IntegrationTest
  include TopicsIntegrationSupport
  include CommentsIntegrationSupport

  def setup
    @group = groups(:one)
    @phil  = users(:phil)
    @topic = topics(:one)

    prepare_javascript_driver
  end

  test "breadcrumbs appear when there is an error in the submission" do
    log_in_as @phil

    visit group_topic_path(@group, @topic)

    submit_new_comment_with ""

    assert page.has_content? "error"
    assert_breadcrumbs
  end

  private

    def assert_breadcrumbs
      within ".breadcrumb" do
        assert page.has_link?    @group.name
        assert page.has_link?    "Topics"
        assert page.has_link?    @topic.title
        assert page.has_content? "New comment"
      end
    end
end
