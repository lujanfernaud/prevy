module UsersHelper
  def organized_events_header(events)
    if events.count > 3
      "Organized (last 3)"
    else
      "Organized"
    end
  end
end
