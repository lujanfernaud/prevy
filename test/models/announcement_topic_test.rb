require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  include UserSupport
  include TopicsTestCaseSupport

  def setup
    @group = groups(:one)
  end

  test "has priority" do
    topic = fake_topic(type: "AnnouncementTopic")
    topic.save

    assert_equal AnnouncementTopic::PRIORITY, topic.priority
  end

  test "priority changes to 0 when updating type to 'Topic'" do
    topic = fake_topic(type: "AnnouncementTopic")
    topic.save

    topic.update_attributes(type: "Topic")

    topic = Topic.last

    assert_equal Topic::PRIORITY, topic.priority
  end

  test "keeps it as announcement on update" do
    topic = fake_topic(type: "AnnouncementTopic")
    topic.save

    topic.update_attributes(title: "Announcement topic updated")

    topic = Topic.last

    assert_equal "AnnouncementTopic", topic.type
    assert_equal AnnouncementTopic::PRIORITY, topic.priority
  end

  test "notifies group members" do
    topic = fake_announcement_topic(@group)

    NewAnnouncementNotification.expects(:call).with(topic)

    topic.save
  end

  test "does not notify group members if group is a sample group" do
    sample_group = groups(:sample_group)
    topic = fake_announcement_topic(sample_group)

    NewAnnouncementNotification.expects(:call).never

    topic.save
  end
end
