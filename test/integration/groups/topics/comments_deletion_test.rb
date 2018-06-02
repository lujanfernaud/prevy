require 'test_helper'

class CommentsDeletionTest < ActionDispatch::IntegrationTest
  include TopicsIntegrationSupport

  def setup
    @group   = groups(:one)
    @phil    = users(:phil)
    @topic   = topics(:one)
    @comment = topic_comments(:one)

    prepare_javascript_driver
  end

  test "user is redirected back to the topic after deleting a comment" do
    log_in_as @phil

    visit group_topic_path(@group, @topic)

    click_on_edit_comment(@comment)

    click_on "Delete comment"

    assert page.has_content? "Comment deleted."
    assert_equal group_topic_path(@group, @topic), current_path
  end
end
