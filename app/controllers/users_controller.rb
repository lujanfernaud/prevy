class UsersController < ApplicationController
  before_action :redirect_to_sign_up, if: :not_logged_in?
  after_action  :verify_authorized

  # User profile
  def show
    @user = find_user

    authorize @user
  end

  # Edit profile
  def edit
    @user = find_user

    authorize @user
  end

  # Update profile
  def update
    @user = find_user

    authorize @user

    if @user.update_attributes(user_params)
      flash[:success] = "Your details have been updated."
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  private

    def find_user
      User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :location, :bio)
    end

    def not_logged_in?
      !current_user
    end

    def redirect_to_sign_up
      redirect_to new_user_registration_path
    end
end
