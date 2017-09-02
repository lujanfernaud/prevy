class SessionsController < ApplicationController
  before_action :check_if_logged_in, only: [:new, :create]

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)

    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      flash[:success] = "You are now logged in."
      redirect_to user_path(@user)
    else
      flash.now[:danger] = "Invalid email/password combination."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def check_if_logged_in
    return unless @current_user

    flash[:info] = "You are already logged in."
    redirect_to user_path(@current_user)
  end
end
