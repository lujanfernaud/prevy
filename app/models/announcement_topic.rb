# frozen_string_literal: true

class AnnouncementTopic < Topic
  PRIORITY = 2

  after_create :notify_group_members

  private

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
