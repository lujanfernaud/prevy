module ApplicationHelper
  include Application::HeaderHelpers
  include Application::AlertHelpers

  def home_page?
    controller_name == "static_pages" && action_name == "home"
  end

  def devise_action?
    devise_actions.include? [controller_name, action_name]
  end

  def devise_actions
    [
      ["registrations", "new"],
      ["registrations", "edit"],
      ["sessions", "new"],
      ["passwords", "new"],
      ["confirmations", "show"],
      ["confirmations", "new"]
    ]
  end

  def user_settings?
    user_settings.include? [controller_name, action_name]
  end

  def user_settings
    [
      ["users", "edit"],
      ["notifications", "edit"]
    ]
  end

  def breadcrumbs_separator
    "<span class='breadcrumbs-separator'> / </span>"
  end
end
