module GroupCountersHelper
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

  def role_count(count)
    return "" unless count > 1

    " (#{count})"
  end
end
