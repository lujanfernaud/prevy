# frozen_string_literal: true

class AnnouncementTopic < Topic
  PRIORITY = 2

  before_create :set_to_announcement
  before_update :set_to_normal_topic, if: :announcement_changed?
  after_create  :notify_group_members

  private

    def set_to_announcement
      self.priority = PRIORITY
      self.announcement = true
    end

    def set_to_normal_topic
      self.becomes!(Topic)
      self.priority = 0
    end

    def notify_group_members
      return if group.sample_group?

      NewAnnouncementNotification.call(self)
    end

    def slug_candidates
      [
        :title,
        [:title, :date],
        [:title, :date, :group_id]
      ]
    end

    def date
      Time.zone.now.strftime("%b %d %Y")
    end
end
