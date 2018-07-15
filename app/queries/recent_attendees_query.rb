# frozen_string_literal: true

class RecentAttendeesQuery
  def self.call(event, limit)
    User.
      joins(:attendances).
      where("attendances.attended_event_id = ?", event.id).
      order("attendances.created_at DESC").
      limit(limit)
  end
end
