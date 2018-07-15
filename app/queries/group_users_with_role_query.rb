# frozen_string_literal: true

class GroupUsersWithRoleQuery
  def self.call(group, role)
    User.confirmed
        .joins(:roles)
        .where(roles: { resource_id: group, name: role.to_s })
  end
end
