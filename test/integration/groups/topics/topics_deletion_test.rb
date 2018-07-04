# frozen_string_literal: true

require 'test_helper'

class TopicsDeletionTest < ActionDispatch::IntegrationTest
  def setup
    @group = groups(:one)
    @phil  = users(:phil)
  end

  test "author deletes topic" do
    topic = fake_topic(group: @group, user: @phil)
    topic.save!

    log_in_as @phil

    visit edit_group_topic_path(@group, topic)

    click_on "Delete"

    assert page.has_content? "Topic deleted."
  end
end
