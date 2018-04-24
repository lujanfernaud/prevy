module GroupsHelper
  include SessionsHelper
  include GroupCountersHelper
  include GroupButtonsHelper

  def has_organizer_role?(user, group)
    user&.has_role? :organizer, group
  end

  def has_member_role?(user, group)
    group.owner == user || user&.has_role?(:member, group)
  end

  def has_membership?(user, group)
    group.owner == user || group.members.include?(user)
  end

  def see_all_members_link(group, quantity:)
    if group.members.count > quantity
      link_to "See all members", group_members_path(group)
    end
  end

  def checked_if_not_set(attribute)
    attribute ? false : true
  end
end
