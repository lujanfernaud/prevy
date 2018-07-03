# frozen_string_literal: true

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
    current_user.notifications.size > 0
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
    current_user.notifications.size
  end

  def button_without_notifications
    link_to user_notifications_path(current_user),
      class: "btn btn-outline-light btn-navbar-menu
        btn-notifications disabled" do
      "Notifications"
    end
  end

  def resource_link(notification)
    return if notification.link.empty?

    link_to notification.link[:text], notification.link[:path]
  end

  def resource_link?(notification)
    !notification.link.empty?
  end
end
