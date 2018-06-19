# frozen_string_literal: true

class EventTopic < Topic
  PRIORITY = 1

  belongs_to :event, touch: true

  private

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
