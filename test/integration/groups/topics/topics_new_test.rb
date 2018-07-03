# frozen_string_literal: true

require 'test_helper'

class TopicsNewTest < ActionDispatch::IntegrationTest
  include TopicsIntegrationSupport

  def setup
    @group = groups(:one)
    @phil  = users(:phil)

    prepare_javascript_driver
  end

  test "user visits 'topics/new'" do
    log_in_as @phil

    visit new_group_topic_path(@group)

    assert_breadcrumbs
  end

  test "breadcrumbs appear when there is an error in the submission" do
    log_in_as @phil

    visit new_group_topic_path(@group)

    fill_topic_fields_with "Hello", ""

    click_on "Create topic"

    assert page.has_content? "error"
    assert_breadcrumbs
  end

  private

    def assert_breadcrumbs
      within ".breadcrumb" do
        assert page.has_link?    @group.name
        assert page.has_link?    "Topics"
        assert page.has_content? "New topic"
      end
    end
end
