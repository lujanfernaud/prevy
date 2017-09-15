module EventsHelper
  def author?(event)
    return unless logged_in?

    current_user.id == event.organizer_id
  end

  def not_attending?(event)
    logged_in? && !event.attendees.include?(current_user)
  end

  def no_attendees?(event)
    event.attendees.count.zero?
  end

  def more_attendees?(event)
    event.attendees.count > 5
  end
end
