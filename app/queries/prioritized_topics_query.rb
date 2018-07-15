# frozen_string_literal: true

class PrioritizedTopicsQuery
  def self.call(group, normal_topics_limit)
    new(group, normal_topics_limit).call
  end

  def initialize(group, normal_topics_limit)
    @normal_topics_limit = normal_topics_limit
    @group  = group
    @events = group.events
    @topics = group.topics
  end

  def call
    remove_priority_to_past_events_topics

    ids = topic_ids(normal_topics_limit)

    topics.where(id: ids).prioritized
  end

  private

    attr_reader :normal_topics_limit, :group, :events, :topics

    def remove_priority_to_past_events_topics
      return if event_topics_to_remove_priority.empty?

      event_topics_to_remove_priority.update_all(priority: 0)
    end

    def event_topics_to_remove_priority
      past_event_ids = events.past.pluck(:id)

      topics.where("event_id IN (?)", past_event_ids)
    end

    def topic_ids(normal_topics_limit)
      special_topics_ids = special_topics.pluck(:id)
      normal_topics_ids  = group.normal_topics.limit(normal_topics_limit).pluck(:id)

      special_topics_ids + normal_topics_ids
    end

    def special_topics
      Topic.where(group: group).special.prioritized
    end
end
