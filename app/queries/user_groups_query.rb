# frozen_string_literal: true

# Returns groups where the user is the owner or has membership.
class UserGroupsQuery
  def self.call(user, relation = Group)
    relation.
      left_outer_joins(
        :group_memberships
      ).
      where(
        'groups.user_id            = :user OR
         group_memberships.user_id = :user',
         user: user
      ).distinct
  end
end
