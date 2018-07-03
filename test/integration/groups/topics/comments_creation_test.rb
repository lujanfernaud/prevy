# frozen_string_literal: true

require 'test_helper'

class CommentsCreationTest < ActionDispatch::IntegrationTest
  include TopicsIntegrationSupport
  include CommentsIntegrationSupport

  def setup
    @group = groups(:one)
    @phil  = users(:phil)
    @topic = topics(:one)

    prepare_javascript_driver
  end

  test "user creates comment with valid data" do
    log_in_as @phil

    visit group_topic_path(@group, @topic)

    submit_new_comment_with "This is great!"

    assert page.has_content? "New comment created."
  end

  test "user creates comment without body" do
    log_in_as @phil

    visit group_topic_path(@group, @topic)

    submit_new_comment_with ""

    assert_error "Body is too short"
  end

  test "user creates comment with too short body" do
    log_in_as @phil

    visit group_topic_path(@group, @topic)

    submit_new_comment_with "H"

    assert_error "Body is too short"
  end
end
