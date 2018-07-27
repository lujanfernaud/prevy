# frozen_string_literal: true

module GroupsHelper
  include Group::TopicsHelper

  def has_moderator_role?(user, group)
    user&.has_role? :moderator, group
  end

  def has_member_role_and_is_confirmed?(user, group)
    return false unless user

    user.has_role?(:member, group) && user.confirmed?
  end

  def authorized?(user, group)
    has_membership_and_is_confirmed?(user, group) ||
      is_group_owner?(user, group)
  end

  def has_membership_and_is_confirmed?(user, group)
    has_membership?(user, group) && user.confirmed?
  end

  def has_membership?(user, group)
    group.members.include?(user)
  end

  def has_membership_but_is_not_confirmed?(user, group)
    has_membership?(user, group) && !user.confirmed?
  end

  def is_group_owner?(user, group)
    group.owner == user
  end

  def invited?
    @group.invited?(current_user, session[:token])
  end

  def checked_if_not_set?(attribute)
    attribute ? false : true
  end
end
