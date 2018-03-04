module ApplicationHelper
  def current_user
    session_user = session[:user_id]
    @current_user ||= User.find(session_user) if session_user
  end

  def breadcrumbs_separator
    "<span class='breadcrumbs-separator'> / </span>"
  end

  def membership_requests_badge
    number = current_user.received_requests.count

    if number.zero?
      ""
    else
      "<span class='ml-2 badge badge-pill badge-primary align-middle'>
        #{number}
      </span>".html_safe
    end
  end
end
