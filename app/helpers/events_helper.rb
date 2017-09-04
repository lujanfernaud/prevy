module EventsHelper
  def author?(event)
    current_user.id == event.organizer_id
  end
end
