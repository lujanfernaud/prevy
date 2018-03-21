module UserMembershipsHelper
  def group_organizers(group)
    pluralize_with_count("Organizer", scope: group.organizers)
  end

  def group_members(group)
    pluralize_with_count("Member", scope: group.members_with_role)
  end

  private

    def pluralize_with_count(title, scope:)
      count = scope.count

      title.pluralize(count) + ": #{count}"
    end
end
