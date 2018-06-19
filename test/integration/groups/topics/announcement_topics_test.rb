require 'test_helper'

class AnnouncementTopicsTest < ActionDispatch::IntegrationTest
  include TopicsSupport
  include TopicsIntegrationSupport

  def setup
    @group = groups(:one)
    @phil  = users(:phil)

    prepare_javascript_driver
  end

  test "group admin creates an announcement topic" do
    log_in_as @phil

    visit group_topics_path(@group)

    submit_new_announcement_topic

    assert page.has_content? "New announcement topic created."

    visit group_topics_path(@group)

    assert_last_topic_has_label "ANNOUNCEMENT:", group: @group
  end

  test "user other than group admin can't create an announcement topic" do
    log_in_as users(:woodell)

    visit new_group_topic_path(@group)

    refute page.has_content? "Announcement"
  end

  test "group admin sets announcement topic to normal topic" do
    announcement_topic = announcement_topics(:announcement_topic_one)

    log_in_as @phil

    visit group_topic_path(@group, announcement_topic)

    click_on "Edit"
    set_topic_type_to "Topic"
    click_on "Update topic"

    topic = find_updated_topic(announcement_topic, group: @group)

    assert page.has_content? "Topic set to normal topic."

    visit group_topics_path(@group)

    refute_topic_has_label "ANNOUNCEMENT:", topic: topic
  end
end
