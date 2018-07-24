# frozen_string_literal: true

class NewAnnouncementNotifier
  def self.call(announcement_topic)
    new(announcement_topic).call
  end

  def initialize(announcement_topic)
    @announcement_topic = announcement_topic
    @group = announcement_topic.group
  end

  def call
    group.members.each do |member|
      create_announcement_topic_notification_for member

      return unless member.group_announcement_emails?

      send_email_to member
    end
  end

  private

    attr_reader :announcement_topic, :group

    def create_announcement_topic_notification_for(member)
      AnnouncementTopicNotification.create(
        user:  member,
        group: group,
        topic: announcement_topic,
        message: "New announcement in #{group.name}: #{announcement_topic.title}"
      )
    end

    def send_email_to(member)
      NotificationMailer.new_announcement_topic(
        member,
        announcement_topic
      ).deliver_later
    end
end
