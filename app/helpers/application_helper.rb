module ApplicationHelper
  include Application::HeaderHelpers
  include Application::AlertHelpers

  def breadcrumbs_separator
    "<span class='breadcrumbs-separator'> / </span>"
  end
end
