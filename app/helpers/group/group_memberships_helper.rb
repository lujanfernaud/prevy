module Group::GroupMembershipsHelper
  include Group::CountersHelper

  def add_or_delete_organizer(user, group)
    return unless group.owner == current_user
    return if group.owner == user

    if user.has_role? :organizer, group
      delete_from_organizers_link(user, group)
    else
      add_to_organizers_link(user, group)
    end
  end

  def add_to_organizers_link(user, group)
    link_to group_organizers_path(group, user_id: user), method: :post,
      class: "mt-2" do
      "Organizer [ <b>+</b> ]".html_safe
    end
  end

  def delete_from_organizers_link(user, group)
    link_to group_organizer_path(group, user), method: :delete,
      confirm: "Are you sure to delete #{user.name} from organizers?",
      class: "mt-2" do
        "Organizer [<b> - </b>]".html_safe
    end
  end
end
