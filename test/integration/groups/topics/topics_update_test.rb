# frozen_string_literal: true

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

    within ".topic-container" do
      refute page.has_content? "Edited"
    end
  end

  test "shows 'edited' if edited after offset" do
    @topic.update_attributes(
      created_at: 1.hour.ago,
      edited_at:  11.minutes.ago
    )

    log_in_as @phil

    visit group_topic_path(@group, @topic)

    within ".topic-container" do
      assert page.has_content? "Edited"
    end
  end

  test "shows 'edited by' if edited by a different user" do
    woodell = users(:woodell)

    @topic.update_attributes(
      created_at: 1.hour.ago,
      edited_at:  11.minutes.ago,
      edited_by:  woodell
    )

    log_in_as @phil

    visit group_topic_path(@group, @topic)

    within ".topic-container" do
      assert page.has_content? "Edited by Woodell"
    end
  end

  test "moderator can update topic" do
    user = users(:woodell)
    @group.add_to_moderators user

    log_in_as user

    visit group_topic_path(@group, @topic)

    update_topic_with "Updated", "Updated body of the test topic."

    assert page.has_content? "Topic updated."
  end

  test "regular user can't update topic" do
    user = users(:carolyn)
    @group.members << user
    @group.remove_from_organizers user

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
