module Group::TopicsHelper
  def is_admin?(group)
    current_user == group.owner
  end

  def is_authorized_to_edit?(resource, group)
    is_author?(resource) || has_moderator_role?(current_user, group)
  end

  def is_author?(resource)
    current_user == resource.user
  end

  def announceable?(topic)
    action_name == "new" || action_name == "edit" && topic.announcement?
  end
end
