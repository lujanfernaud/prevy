# frozen_string_literal: true

class EventTopic < Topic
  PRIORITY = 1

  belongs_to :event, touch: true

  before_save :set_priority

  private

    def set_priority
      self.priority = PRIORITY
    end

    def slug_candidates
      [
        :title,
        [:title, :event_start_date],
        [:title, :event_start_date, :group_id]
      ]
    end

    def event_start_date
      event.start_date.strftime("%b %d %Y")
    end
end
