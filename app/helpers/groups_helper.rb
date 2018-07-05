# frozen_string_literal: true

module GroupsHelper
  include SessionsHelper
  include Group::CountersHelper
  include Group::ButtonsHelper
  include Group::TopicsHelper

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

  def has_organizer_role?(user, group)
    user&.has_role? :organizer, group
  end

  def has_moderator_role?(user, group)
    user&.has_role? :moderator, group
  end

  def has_member_role?(user, group)
    group.owner == user || user&.has_role?(:member, group)
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

  def invited?(group)
    group.invitation_tokens.include?(session[:token])
  end

  def admin_name_or_link(group)
    owner = group.owner

    if invited?(group)
      link_to owner.name, group_member_path(group, owner)
    else
      owner.name
    end
  end

  def checked_if_not_set(attribute)
    attribute ? false : true
  end

  def top_members(group)
    if group.members_with_role.size > Group::TOP_MEMBERS_SHOWN
      group.top_members
    else
      group.top_members(limit: Group::TOP_MEMBERS_SHOWN / 2)
    end
  end
end
