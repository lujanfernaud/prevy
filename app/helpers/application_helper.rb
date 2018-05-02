module ApplicationHelper
  include Application::HeaderHelpers
  include Application::AlertHelpers

  def home_page?
    controller_name == "static_pages" && action_name == "home"
  end

  def devise_action?
    sign_up? || log_in? || new_password? || new_confirmation?
  end

  def sign_up?
    controller_name == "registrations" && action_name == "new"
  end

  def log_in?
    controller_name == "sessions" && action_name == "new"
  end

  def new_password?
    controller_name == "passwords" && action_name == "new"
  end

  def new_confirmation?
    controller_name == "confirmations" && action_name == "new"
  end

  def breadcrumbs_separator
    "<span class='breadcrumbs-separator'> / </span>"
  end
end
