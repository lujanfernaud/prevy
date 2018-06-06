# frozen_string_literal: true

class NewAnnouncementTopicJob < ApplicationJob
  def perform(user, topic)
    NotificationMailer.new_announcement_topic(user, topic).deliver_now
  end
end
