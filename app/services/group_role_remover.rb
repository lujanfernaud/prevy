# frozen_string_literal: true

class GroupRoleRemover
  SPECIAL_ROLES = ["organizer", "moderator"].freeze

  def self.call(group, user, role)
    new(group, user, role).call
  end

  def initialize(group, user, role)
    @group = group
    @user  = user
    @role  = role
  end

  def call
    if user_has_more_than_one_special_role?
      user.remove_role role, group
    else
      change_role_for user, remove_as: role, add_as: :member
    end
  end

  private

    attr_reader :group, :user, :role

    def user_has_more_than_one_special_role?
      (SPECIAL_ROLES - user.group_roles(group)).empty?
    end

    def change_role_for(user, remove_as:, add_as:)
      user.remove_role remove_as, group
      user.add_role add_as, group
    end
end
