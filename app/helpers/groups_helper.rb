module GroupsHelper
  include SessionsHelper

  def authorized?(user, group)
    group.owner == user || group.members.include?(user)
  end

  def see_all_members_link(group, quantity:)
    if group.members.count > quantity
      link_to "See all members", group_members_path(group)
    end
  end

  def membership_button(group)
    if group.private? && logged_in?
      link_to "Request invite", "#",
        class: "btn btn-primary btn-block btn-lg mt-3"
    elsif group.private?
      link_to "Log in to request invite", "#",
        class: "btn btn-primary btn-block btn-lg mt-3"
    elsif !group.private? && logged_in?
      link_to "Join group", "#",
        class: "btn btn-primary btn-block btn-lg mt-3"
    else
      link_to "Log in to join group", "#",
        class: "btn btn-primary btn-block btn-lg mt-3"
    end
  end
end
