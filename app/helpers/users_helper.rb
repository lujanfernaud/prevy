# frozen_string_literal: true

# TODO: Remove file

module UsersHelper
  def organized_events_header(events)
    if events.size > 3
      "Organized (last 3)"
    else
      "Organized"
    end
  end
end
