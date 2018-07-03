# frozen_string_literal: true

# == Schema Information
#
# Table name: topics
#
#  id                :bigint(8)        not null, primary key
#  group_id          :bigint(8)
#  user_id           :bigint(8)
#  title             :string
#  body              :text
#  slug              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  type              :string           default("Topic")
#  event_id          :bigint(8)
#  priority          :integer          default(0)
#  announcement      :boolean          default(FALSE)
#  edited_by_id      :bigint(8)
#  edited_at         :datetime
#  last_commented_at :datetime
#

require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  include UserSupport
  include TopicsTestCaseSupport
  include MailerSupport

  def setup
    @group = groups(:one)

    stub_new_announcement_topic_mailer
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
