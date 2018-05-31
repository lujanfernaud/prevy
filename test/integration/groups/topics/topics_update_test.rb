require 'test_helper'

class TopicsUpdateTest < ActionDispatch::IntegrationTest
  include TopicsIntegrationSupport

  def setup
    @group = groups(:one)
    @phil  = users(:phil)
    @topic = topics(:one)

    prepare_javascript_driver
  end

  test "author updates topic" do
    log_in_as @phil

    visit group_topic_path(@group, @topic)

    update_topic_with "Updated", "Updated body of the test topic."

    assert page.has_content? "Topic updated."
  end

  test "regular user can't update topic" do
    user = users(:carolyn)
    @group.members << user

    log_in_as user

    visit group_topic_path(@group, @topic)

    refute_edit_link
  end

  private

    def refute_edit_link
      within ".topic-container" do
        refute page.has_link? "Edit"
      end
    end
end
