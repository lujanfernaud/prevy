class ApplicationController < ActionController::Base
  before_action :store_user_location, if: :storable_location?

  include Pundit
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def pundit_user
    UserContext.new(current_user, params)
  end

  private

    def storable_location?
      request.get? &&
        is_navigational_format? &&
        !devise_controller? &&
        !request.xhr?
    end

    def store_user_location
      store_location_for(:user, request.fullpath)
    end

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referrer || root_path)
    end
end
