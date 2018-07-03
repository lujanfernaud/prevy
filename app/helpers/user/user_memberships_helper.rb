# frozen_string_literal: true

module User::UserMembershipsHelper
  def group_name_with_link(group)
    link_to group.name, group_path(group)
  end

  def user_is_organizer_but_not_owner(group, user)
    user.has_role?(:organizer, group) &&
      !user.owned_groups.include?(group)
  end

  def group_organizers(group)
    pluralize_with_count("Organizer", scope: group.organizers)
  end

  def group_members(group)
    pluralize_with_count("Member", scope: group.members_with_role)
  end

  def pluralize_with_count(title, scope:)
    count = scope.count

    title.pluralize(count) + ": #{count}"
  end

  def edit_group_link(group)
    if group.sample_group?
      link_to "Edit group", "#", class: "text-muted"
    else
      link_to "Edit group", edit_group_path(group)
    end
  end

  def edit_roles_link(group)
    link_to "Edit roles", group_roles_path(group)
  end

  def cancel_membership_link(group)
    link_to "Cancel membership",
      group_membership_path(group, current_user),
      method: :delete,
      data: { confirm: "Are you sure to cancel your membership to '#{group.name}'?"}
  end
end
