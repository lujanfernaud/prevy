# frozen_string_literal: true

require 'test_helper'

class PinnedTopicsTest < ActionDispatch::IntegrationTest
  include TopicsIntegrationSupport

  def setup
    @group = groups(:one)
    @phil  = users(:phil)

    prepare_javascript_driver
  end

  test "group admin creates a pinned topic" do
    log_in_as @phil

    visit group_topics_path(@group)

    submit_new_pinned_topic

    assert page.has_content? "New pinned topic created."

    visit group_topics_path(@group)

    assert_last_topic_has_label "PINNED:", group: @group
  end

  test "user other than group admin can't create a pinned topic" do
    log_in_as users(:woodell)

    visit new_group_topic_path(@group)

    refute page.has_content? "Pinned"
  end

  test "group admin sets pinned topic to normal topic" do
    group = fake_group
    group.save!

    topic = fake_topic(group: group, type: "PinnedTopic")
    topic.save!

    log_in_as @phil

    visit group_topic_path(group, topic)

    click_on "Edit"
    set_topic_type_to "Topic"
    click_on "Update topic"

    topic = group.topics.last

    assert page.has_content? "Topic set to normal topic."

    visit group_topics_path(group)

    refute_topic_has_label "PINNED:", topic: topic
  end
end
