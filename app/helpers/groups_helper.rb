# frozen_string_literal: true

module GroupsHelper
  include Group::ButtonsHelper
  include Group::TopicsHelper

  def has_organizer_role?(user, group)
    user&.has_role? :organizer, group
  end

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

  def show_create_group_link_or_unconfirmed_alert(user, group)
    return unless is_group_owner?(user, group)
    return unless group.sample_group?

    if user.confirmed?
      link_to "Click here to create your first group!", new_group_path
    else
      content_tag :div, class: "mt-4" do
        create_group_unconfirmed_account_alert
      end
    end
  end

  def is_group_owner?(user, group)
    group.owner == user
  end

  def admin_name_or_link(group)
    owner = group.owner

    if invited?
      link_to owner.name, group_member_path(group, owner)
    else
      owner.name
    end
  end

  def invited?
    return false unless session[:token]

    InvitationAuthorizer.call(session[:token], @group, current_user)
  end

  def checked_if_not_set?(attribute)
    attribute ? false : true
  end
end
