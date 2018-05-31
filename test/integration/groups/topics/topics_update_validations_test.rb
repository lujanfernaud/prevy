require 'test_helper'

class TopicsUpdateValidationsTest < ActionDispatch::IntegrationTest
  include TopicsIntegrationSupport

  def setup
    @group = groups(:one)
    @phil  = users(:phil)
    @topic = topics(:one)

    prepare_javascript_driver
  end

  test "author updates topic without title" do
    log_in_as @phil

    visit group_topic_path(@group, @topic)

    update_topic_with "", "Updated body of the test topic."

    assert_error "Title can't be blank"
  end

  test "author updates topic with too short title" do
    log_in_as @phil

    visit group_topic_path(@group, @topic)

    update_topic_with "H", "This is the body of the test topic."

    assert_error "Title is too short"
  end

  test "author updates topic without body" do
    log_in_as @phil

    visit group_topic_path(@group, @topic)

    update_topic_with "Test topic", ""

    assert_error "Body is too short"
  end

  test "author updates topic with too short body" do
    log_in_as @phil

    visit group_topic_path(@group, @topic)

    update_topic_with "Test topic", "Hello"

    assert_error "Body is too short"
  end
end
