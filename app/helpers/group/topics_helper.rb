# frozen_string_literal: true

module Group::TopicsHelper
  def announceable?(topic)
    action_name == "new" || action_name == "edit" && topic.announcement?
  end

  def is_authorized_to_edit?(resource, group)
    is_author?(resource) || has_moderator_role?(current_user, group)
  end

  def is_author?(resource)
    current_user == resource.user
  end

  def resource_comments_path(group, topic)
    if topic.event?
      group_event_path(group, topic.event) + "#comments"
    else
      group_topic_path(group, topic)
    end
  end
end
