module Group::CountersHelper
  def organizer_title
    count = @group.organizers.count

    "Organizer".pluralize(count) + role_count(count)
  end

  def role_count(count)
    return "" unless count > 1

    " (#{count})"
  end

  def members_title_with_count
    "Members (#{@group.members_with_role.count})"
  end

  def attendees_title_with_count
    "Attendees (#{@event.attendees.count})"
  end
end
