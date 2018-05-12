module EventsHelper
  def website?
    @event.website && !@event.website.empty?
  end

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

  def same_time?(event)
    event.start_date.strftime("%H:%M") == event.end_date.strftime("%H:%M")
  end

  def see_all_attendees_link(event, quantity:)
    if event.attendees.count > quantity
      link_to "See all attendees", event_attendances_path(event)
    end
  end

  def default_start_date
    1.week.from_now.round_to(1.hour)
  end

  def default_end_date
    (1.week.from_now + 1.hour).round_to(1.hour)
  end
end
