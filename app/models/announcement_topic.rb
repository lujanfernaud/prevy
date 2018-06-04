# frozen_string_literal: true

class AnnouncementTopic < Topic
  PRIORITY = 2

  before_create :set_to_announcement
  before_update :set_to_normal_topic, if: :announcement_changed?

  private

    def set_to_announcement
      self.priority = PRIORITY
      self.announcement = true
    end

    def set_to_normal_topic
      self.becomes!(Topic)
      self.priority = 0
    end
end
