module Group::TopicsHelper
  def is_authorized_to_edit?(resource, group)
    is_author?(resource) || has_organizer_role?(current_user, group)
  end

  def is_author?(resource)
    current_user == resource.user
  end
end
