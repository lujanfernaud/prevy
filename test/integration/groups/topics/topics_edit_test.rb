require 'test_helper'

class TopicsEditTest < ActionDispatch::IntegrationTest
  include TopicsIntegrationSupport

  def setup
    @group = groups(:one)
    @phil  = users(:phil)
    @topic = topics(:one)

    prepare_javascript_driver
  end

  test "user visits 'topics/edit'" do
    log_in_as @phil

    visit edit_group_topic_path(@group, @topic)

    assert_breadcrumbs
  end

  test "breadcrumbs appear when there is an error in the submission" do
    log_in_as @phil

    visit edit_group_topic_path(@group, @topic)

    fill_topic_fields_with "Hello", ""

    click_on "Update topic"

    assert page.has_content? "error"
    assert_breadcrumbs
  end

  private

    def assert_breadcrumbs
      within ".breadcrumb" do
        assert page.has_link?    @group.name
        assert page.has_link?    "Topics"
        assert page.has_content? "Edit topic"
      end
    end
end
