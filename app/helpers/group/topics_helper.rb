module Group::TopicsHelper
  def is_author?(resource)
    current_user == resource.user
  end
end
