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
