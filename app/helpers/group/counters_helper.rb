# frozen_string_literal: true

module Group::CountersHelper
  def organizer_title
    count = @group.organizers.size

    "Organizer".pluralize(count) + role_count(count)
  end

  def role_count(count)
    return "" unless count > 1

    " (#{count})"
  end

  def members_title_with_count
    "Members (#{@group.members_count})"
  end
end
