module Group::CountersHelper
  def organizer_title
    count = @group.organizers.count

    "Organizer".pluralize(count) + role_count(count)
  end

  def members_title_with_count
    members_title + role_count(@group.members_with_role.count)
  end

  def members_title
    "Member".pluralize(@group.members_with_role.count)
  end

  def attendees_title_with_count
    attendees_title + role_count(@event.attendees.count)
  end

  def attendees_title
    "Attendee".pluralize(@event.attendees.count)
  end

  def role_count(count)
    return "" unless count > 1

    " (#{count})"
  end
end
