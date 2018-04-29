module User::UserMembershipsHelper
  def group_organizers(group)
    pluralize_with_count("Organizer", scope: group.organizers)
  end

  def group_members(group)
    pluralize_with_count("Member", scope: group.members_with_role)
  end

  def edit_group_link(group)
    if group.sample_group?
      link_to "Edit group", "#", class: "text-muted"
    else
      link_to "Edit group", edit_group_path(group)
    end
  end

  private

    def pluralize_with_count(title, scope:)
      count = scope.count

      title.pluralize(count) + ": #{count}"
    end
end
