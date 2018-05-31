module GroupsHelper
  include SessionsHelper
  include Group::CountersHelper
  include Group::ButtonsHelper
  include Group::TopicsHelper

  def sample_group_link(user, group)
    return unless is_group_owner(user, group)
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

  def has_member_role?(user, group)
    group.owner == user || user&.has_role?(:member, group)
  end

  def authorized?(user, group)
    has_membership_and_is_confirmed?(user, group) ||
      is_group_owner(user, group)
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

  def is_group_owner(user, group)
    group.owner == user
  end

  def checked_if_not_set(attribute)
    attribute ? false : true
  end
end
