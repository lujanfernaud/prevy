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

class PinnedTopicTest < ActiveSupport::TestCase
  test "has priority" do
    topic = fake_topic(type: "PinnedTopic")
    topic.save

    assert_equal PinnedTopic::PRIORITY, topic.priority
  end

  test "priority changes to 0 when updating type to 'Topic'" do
    topic = fake_topic(type: "PinnedTopic")
    topic.save

    topic.update_attributes(type: "Topic")

    topic = Topic.last

    assert_equal Topic::PRIORITY, topic.priority
  end

  test "keeps it as pinned topic on update" do
    topic = fake_topic(type: "PinnedTopic")
    topic.save

    topic.update_attributes(title: "Pinned topic updated")

    topic = Topic.last

    assert_equal "PinnedTopic", topic.type
    assert_equal PinnedTopic::PRIORITY, topic.priority
  end

end
