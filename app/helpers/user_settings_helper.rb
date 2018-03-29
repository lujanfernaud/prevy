module UserSettingsHelper
  def link_to_account_settings_for(user)
    link_to "Account", edit_user_registration_path(user),
      class: "nav-link #{'active' if registrations_controller?}"
  end

  def link_to_profile_settings_for(user)
    link_to "Profile", edit_user_path(user),
      class: "nav-link #{'active' if users_controller?}"
  end

  def link_to_notification_settings_for(user)
    link_to "Notifications", user_notification_settings_path(user),
      class: "nav-link #{'active' if notifications_controller?}"
  end

  def registrations_controller?
    controller.controller_name == "registrations"
  end

  def users_controller?
    controller.controller_name == "users"
  end

  def notifications_controller?
    controller.controller_name == "notifications"
  end
end
