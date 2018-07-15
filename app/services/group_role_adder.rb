# frozen_string_literal: true

class GroupRoleAdder
  def self.call(group, user, role)
    new(group, user, role).call
  end

  def initialize(group, user, role)
    @group = group
    @user  = user
    @role  = role
  end

  def call
    if user_has_member_role?
      change_role_for user, remove_as: :member, add_as: role
    else
      user.add_role role, group
    end
  end

  private

    attr_reader :group, :user, :role

    def user_has_member_role?
      user.has_role? :member, group
    end

    def change_role_for(user, remove_as:, add_as:)
      user.remove_role remove_as, group
      user.add_role add_as, group
    end
end
