# frozen_string_literal: true

# == Schema Information
#
# Table name: topics
#
#  id                :bigint(8)        not null, primary key
#  announcement      :boolean          default(FALSE)
#  body              :text
#  comments_count    :integer          default(0), not null
#  edited_at         :datetime
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

class PinnedTopicTest < ActiveSupport::TestCase
  test "has priority" do
    topic = fake_topic(type: "PinnedTopic")
    topic.save!

    assert_equal PinnedTopic::PRIORITY, topic.priority
  end

  test "priority changes to 0 when updating type to 'Topic'" do
    topic = fake_topic(type: "PinnedTopic")
    topic.save!

    topic.update_attributes(type: "Topic")

    topic = Topic.last

    assert_equal Topic::PRIORITY, topic.priority
  end

  test "keeps it as pinned topic on update" do
    topic = fake_topic(type: "PinnedTopic")
    topic.save!

    topic.update_attributes(title: "Pinned topic updated")

    topic = Topic.last

    assert_equal "PinnedTopic", topic.type
    assert_equal PinnedTopic::PRIORITY, topic.priority
  end

end
