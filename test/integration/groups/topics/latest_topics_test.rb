# frozen_string_literal: true

require 'test_helper'

class LatestTopicsTest < ActionDispatch::IntegrationTest
  include TopicsIntegrationSupport

  def setup
    @phil = users(:phil)
    @nike_group   = groups(:one)
    @pennys_group = groups(:two)
  end

  test "doesn't show 'see all topics' button with not enough topics" do
    log_in_as(@phil)

    visit group_path(@pennys_group)

    assert_topics(@pennys_group)

    refute_topics_box_button "See all topics"
    assert_topics_box_button "Submit a new topic"
  end

  test "shows 'see all topics' button with enough topics" do
    log_in_as(@phil)

    visit group_path(@nike_group)

    assert_topics_box_button "See all topics"
    assert_topics_box_button "Submit a new topic"
  end

  test "submit a new topic" do
    log_in_as(@phil)

    visit group_path(@nike_group)

    click_on "Submit a new topic"

    assert_equal current_path, new_group_topic_path(@nike_group)
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
