class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "Account created. Welcome!"
      redirect_to user_path(@user)
    else
      render "signup"
    end
  end

  def show
    @user = User.find_by(id: params[:id])

    unless @user
      redirect_to root_url
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email,
                                   :password, :password_confirmation)
    end
end
