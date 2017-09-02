module ApplicationHelper
  def current_user
    session_user = session[:user_id]
    @current_user ||= User.find(session_user) if session_user
  end
end
