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

class EventTopicTest < ActiveSupport::TestCase
  def setup
    stub_requests_to_googleapis
  end

  test "has priority" do
    event = fake_event
    event.save

    assert_equal EventTopic::PRIORITY, event.topic.priority
  end

  test "keeps it as event topic on update" do
    event = fake_event
    event.save
    topic = event.topic

    topic.update_attributes(title: "Event topic updated")

    topic = Topic.last

    assert_equal "EventTopic", topic.type
    assert_equal EventTopic::PRIORITY, topic.priority
  end

  test "touches event when adding a comment" do
    event = fake_event
    event.save
    topic = event.topic

    event.update_attributes(title: "Test event")
    event.update_attributes(updated_at: 1.day.ago)

    assert_in_delta 1.day.ago, event.updated_at, 1.minute

    topic.comments.create!(user: SampleUser.all.sample, body: "Test comment")

    assert_in_delta topic.reload.updated_at, event.reload.updated_at, 1.minute
  end
end
