require 'test_helper'

class TopicsCreationTest < ActionDispatch::IntegrationTest
  include TopicsIntegrationSupport

  def setup
    @group = groups(:one)
    @phil  = users(:phil)

    prepare_javascript_driver
  end

  test "user creates topic with valid data" do
    log_in_as @phil

    visit group_topics_path(@group)

    submit_new_topic_with "Test topic", "This is the body of the test topic."

    assert page.has_content? "New topic created."
  end

  test "user creates topic without title" do
    log_in_as @phil

    visit group_topics_path(@group)

    submit_new_topic_with "", "This is the body of the test topic."

    assert_error "Title can't be blank"
  end

  test "user creates topic with too short title" do
    log_in_as @phil

    visit group_topics_path(@group)

    submit_new_topic_with "H", "This is the body of the test topic."

    assert_error "Title is too short"
  end

  test "user creates topic without body" do
    log_in_as @phil

    visit group_topics_path(@group)

    submit_new_topic_with "Test topic", ""

    assert_error "Body is too short"
  end

  test "user creates topic with too short body" do
    log_in_as @phil

    visit group_topics_path(@group)

    submit_new_topic_with "Test topic", "Hello"

    assert_error "Body is too short"
  end
end
