# frozen_string_literal: true

class OrganizersAndModeratorsQuery
  ROLES = ["organizer", "moderator"]

  def self.call(group)
    User.joins(:roles)
        .where(roles: { resource_id: group, name: ROLES })
        .order(:name)
        .distinct
  end
end
