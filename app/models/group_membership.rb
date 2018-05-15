class GroupMembership < ApplicationRecord
  before_save    :add_role_to_user
  before_destroy :remove_all_user_roles_for_group

  belongs_to :user
  belongs_to :group

  has_one :notification, dependent: :destroy

  private

    def add_role_to_user
      if group.all_members_can_create_events?
        user.add_role :organizer, group
      else
        user.add_role :member, group
      end
    end

    def remove_all_user_roles_for_group
      user_roles.each do |role|
        user.remove_role role, group
      end
    end

    def user_roles
      user.roles.where(resource: group).map do |role|
        role.name.to_sym
      end
    end
end
