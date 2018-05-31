require 'test_helper'

class TopicsIndexTest < ActionDispatch::IntegrationTest
  include TopicsIntegrationSupport

  def setup
    @topic = topics(:one)
    @group = groups(:one)
    @phil  = users(:phil)
  end

  test "user visits index" do
    log_in_as @phil

    visit group_topics_path(@group)

    assert_breadcrumbs
    assert_topics(@group)
    assert_pagination

    click_on "Submit a new topic"

    assert_equal current_path, new_group_topic_path(@group)
  end

  private

    def assert_breadcrumbs
      within ".breadcrumb" do
        assert page.has_link?    @group.name
        assert page.has_content? "Topics"
      end
    end
end
