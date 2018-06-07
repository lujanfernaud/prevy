require 'test_helper'

class CommentsShowTest < ActionDispatch::IntegrationTest
  def setup
    @group   = groups(:one)
    @phil    = users(:phil)
    @topic   = topics(:one)
    @comment = topic_comments(:one)
  end

  test "comment has content" do
    log_in_as @phil

    visit group_topic_path(@group, @topic)

    assert page.has_link?    @comment.user.name
    assert page.has_content? @comment.body
  end
end
