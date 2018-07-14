# frozen_string_literal: true

require 'test_helper'

class LatestTopicsTest < ActionDispatch::IntegrationTest
  include TopicsIntegrationSupport

  def setup
    stub_sample_content_for_new_users

    @phil  = users(:phil)
    @group = create :group, owner: @phil
  end

  test "doesn't show 'see all topics' button with not enough topics" do
    create_list :topic, 5, group: @group

    log_in_as(@phil)

    visit group_path(@group)

    assert_topics(@group)

    refute_topics_box_button "See all topics"
    assert_topics_box_button "Submit a new topic"
  end

  test "shows 'see all topics' button with enough topics" do
    create_list :topic, 10, group: @group

    log_in_as(@phil)

    visit group_path(@group)

    assert_topics_box_button "See all topics"
    assert_topics_box_button "Submit a new topic"
  end

  test "submit a new topic" do
    log_in_as(@phil)

    visit group_path(@group)

    click_on "Submit a new topic"

    assert_equal current_path, new_group_topic_path(@group)
  end

  private

    def assert_topics_box_button(text)
      within ".topics-box" do
        assert page.has_link? text
      end
    end

    def refute_topics_box_button(text)
      within ".topics-box" do
        refute page.has_link? text
      end
    end
end
