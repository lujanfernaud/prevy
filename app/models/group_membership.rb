class GroupMembership < ApplicationRecord
  belongs_to :user
  belongs_to :group

  has_one :notification, dependent: :destroy

  before_save    :add_user_role
  before_create  :create_user_group_comments_count
  before_destroy :destroy_user_group_comments_count
  before_destroy :remove_user_roles

  private

    def add_user_role
      if group.all_members_can_create_events?
        user.add_role :organizer, group
      else
        user.add_role :member, group
      end
    end

    def create_user_group_comments_count
      UserGroupCommentsCount.create!(user: user, group: group)
    end

    def destroy_user_group_comments_count
      UserGroupCommentsCount.find_by(user: user, group: group).destroy
    end

    def remove_user_roles
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
