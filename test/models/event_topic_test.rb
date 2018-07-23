# frozen_string_literal: true

# == Schema Information
#
# Table name: topics
#
#  id                :bigint(8)        not null, primary key
#  announcement      :boolean          default(FALSE)
#  body              :text
#  comments_count    :integer          default(0), not null
#  edited_at         :datetime         not null
#  last_commented_at :datetime
#  priority          :integer          default(0)
#  slug              :string
#  title             :string
#  type              :string           default("Topic")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  edited_by_id      :bigint(8)
#  event_id          :bigint(8)
#  group_id          :bigint(8)
#  user_id           :bigint(8)
#
# Indexes
#
#  index_topics_on_event_id           (event_id)
#  index_topics_on_group_id           (group_id)
#  index_topics_on_last_commented_at  (last_commented_at)
#  index_topics_on_priority           (priority)
#  index_topics_on_slug               (slug)
#  index_topics_on_user_id            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (user_id => users.id)
#

require 'test_helper'

class EventTopicTest < ActiveSupport::TestCase
  def setup
    stub_requests_to_googleapis
  end

  test "has priority" do
    event = fake_event
    event.save!

    assert_equal EventTopic::PRIORITY, event.topic.priority
  end

  test "keeps it as event topic on update" do
    event = fake_event
    event.save!
    topic = event.topic

    topic.update_attributes(title: "Event topic updated")

    topic = Topic.last

    assert_equal "EventTopic", topic.type
    assert_equal EventTopic::PRIORITY, topic.priority
  end

  test "touches event when adding a comment" do
    event = fake_event
    event.save!
    topic = event.topic

    event.update_attributes(title: "Test event")
    event.update_attributes(updated_at: 1.day.ago)

    assert_in_delta 1.day.ago, event.updated_at, 1.minute

    topic.comments.create!(user: SampleUser.all.sample, body: "Test comment")

    assert_in_delta topic.reload.updated_at, event.reload.updated_at, 1.minute
  end
end
