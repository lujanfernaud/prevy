# frozen_string_literal: true

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

  def more_attendees?(event)
    event.attendees.count > Event::RECENT_ATTENDEES_SHOWN
  end

  def same_time?(event)
    event.start_date.strftime("%H:%M") == event.end_date.strftime("%H:%M")
  end

  def default_start_date
    1.week.from_now.round_to(1.hour)
  end

  def default_end_date
    (1.week.from_now + 1.hour).round_to(1.hour)
  end

  def edit_event_box(event, group)
    return unless author?(event)

    content_tag :div, class: "box box--sidebar p-3" do
      if event.sample_event?
        edit_event_button_disabled
      else
        edit_event_button(event, group)
      end
    end
  end

  def edit_event_button_disabled
    button_tag "Edit event",
      class: "btn btn-primary btn-block btn-lg disabled"
  end

  def edit_event_button(event, group)
    link_to "Edit event", edit_group_event_path(group, event),
      class: "btn btn-primary btn-block btn-lg"
  end
end
