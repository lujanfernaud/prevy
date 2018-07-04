# frozen_string_literal: true

# == Schema Information
#
# Table name: group_memberships
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :bigint(8)
#  user_id    :bigint(8)
#
# Indexes
#
#  index_group_memberships_on_group_id  (group_id)
#  index_group_memberships_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (user_id => users.id)
#

class GroupMembership < ApplicationRecord
  belongs_to :user
  belongs_to :group, counter_cache: :members_count

  has_one :notification, dependent: :destroy

  before_save    :add_user_role
  before_create  :create_user_group_points
  before_destroy :destroy_user_group_points
  before_destroy :remove_user_roles

  private

    def add_user_role
      if group.all_members_can_create_events?
        user.add_role :organizer, group
      else
        user.add_role :member, group
      end
    end

    def create_user_group_points
      UserGroupPoints.create!(user: user, group: group)
    end

    def destroy_user_group_points
      UserGroupPoints.find_by(user: user, group: group).destroy
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
