module NotificationsHelper
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
      class: "btn btn-primary btn-notifications" do
      "Notifications #{notifications_badge}".html_safe
    end
  end

  def notifications_badge
    return unless notifications?

    "<span class='ml-2 badge badge-pill badge-light align-middle'>
      #{notifications_count}
    </span>".html_safe
  end

  def notifications_count
    current_user.notifications.count
  end

  def button_without_notifications
    link_to user_notifications_path(current_user),
      class: "btn btn-outline-secondary btn-notifications" do
      "Notifications"
    end
  end

  def see_notification_link(notification)
    case notification.type
    when "MembershipRequestNotification"
      go_to_request_link(notification)
    when "GroupMembershipNotification", "GroupRoleNotification"
      go_to_group_link(notification)
    end
  end

  def go_to_request_link(notification)
    return unless notification.membership_request

    link_to "Go to request",
      user_membership_request_path(
        current_user, notification.membership_request)
  end

  def go_to_group_link(notification)
    link_to "Go to group", group_path(notification.group)
  end
end
