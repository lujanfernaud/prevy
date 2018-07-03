# frozen_string_literal: true

module TopicsSupport
  def find_updated_topic(topic, group:)
    group.topics.where(title: topic.title, body: topic.body).first
  end
end
