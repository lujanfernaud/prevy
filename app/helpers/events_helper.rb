module EventsHelper
  def author?(event)
    return unless logged_in?

    current_user.id == event.organizer_id
  end
end
