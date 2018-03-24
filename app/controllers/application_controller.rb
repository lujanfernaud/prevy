class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  before_action :set_current_user

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def pundit_user
    UserContext.new(current_user, params)
  end

  private

    def set_current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def current_user
      @current_user
    end

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referrer || root_path)
    end
end
