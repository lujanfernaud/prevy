require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  include UserSupport
  include TopicsSupport
  include TopicsTestCaseSupport

  def setup
    @group = groups(:one)
  end

  test "sets priority and announcement on creation" do
    topic = fake_announcement_topic(@group)

    topic.save

    assert_announcement_topic_properties(topic)
  end

  test "sets it to normal topic on update when 'announcement' changes" do
    topic = announcement_topics(:announcement_topic_one)

    topic.update_attributes(announcement: false)

    topic = find_updated_topic(topic, group: @group)

    assert_normal_topic_properties(topic)
  end

  test "keeps it as announcement on update" do
    topic = announcement_topics(:announcement_topic_one)

    topic.update_attributes(title: "Announcement topic updated")

    topic = find_updated_topic(topic, group: @group)

    assert_announcement_topic_properties(topic)
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

  private

    def assert_announcement_topic_properties(topic)
      assert_equal "AnnouncementTopic", topic.class.name
      assert_equal "AnnouncementTopic", topic.type
      assert_equal AnnouncementTopic::PRIORITY, topic.priority
      assert       topic.announcement?
    end

    def assert_normal_topic_properties(topic)
      assert_equal "Topic", topic.class.name
      assert_nil   topic.type
      assert_equal 0, topic.priority
      refute       topic.announcement?
    end
end
