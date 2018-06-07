module User::NotificationsHelper
  def notifications_button
    return unless current_user

    if notifications?
      button_with_notifications
    else
      button_without_notifications
    end
  end

  def notifications?
    current_user.notifications.count > 0
  end

  def button_with_notifications
    link_to user_notifications_path(current_user),
      class: "btn btn-light btn-navbar-menu btn-notifications" do
      "Notifications #{notifications_badge}".html_safe
    end
  end

  def notifications_badge
    return unless notifications?

    "<span class='ml-2 badge badge-pill badge-dark align-middle bg-primary-dark'>
      #{notifications_count}
    </span>".html_safe
  end

  def notifications_count
    current_user.notifications.count
  end

  def button_without_notifications
    link_to user_notifications_path(current_user),
      class: "btn btn-outline-light btn-navbar-menu
        btn-notifications disabled" do
      "Notifications"
    end
  end

  # TODO: Use polymorphism
  def see_notification_link(notification)
    case notification.type
    when "MembershipRequestNotification"
      resource_link(notification)
    when "AnnouncementTopicNotification"
      resource_link(notification)
    when "GroupRoleNotification"
      resource_link(notification)
    when "GroupMembershipNotification"
      go_to_group_link(notification)
    end
  end

  def resource_link(notification)
    return unless notification.link

    link_to notification.link[:text], notification.link[:path]
  end

  def go_to_request_link(notification)
    return unless notification.membership_request

    link_to "Go to request",
      user_notification_redirecter_path(
        notification: notification,
        membership_request: notification.membership_request)
  end

  def go_to_group_link(notification)
    link_to "Go to group",
      user_notification_redirecter_path(
        notification: notification,
        group: notification.group)
  end

  def go_to_announcement_link(notification)
    link_to "Go to announcement",
      user_notification_redirecter_path(
        notification: notification,
        group: notification.group,
        topic: notification.topic)
  end

  def notification_link?(notification)
    return false if membership_request_declined?(notification)

    types = ["MembershipRequestNotification",
             "GroupMembershipNotification",
             "GroupRoleNotification",
             "AnnouncementTopicNotification"]

    types.include?(notification.type)
  end

  def membership_request_declined?(notification)
    notification.type == "MembershipRequestNotification" &&
      notification.message.match(/declined/)
  end
end
