class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "Account created. Welcome!"
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def show
    redirect_to root_url unless @user

    @attended_events = @user.past_attended_events
    @upcoming_events = @user.upcoming_attended_events
    @last_organized_events = @user.last_organized_events
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Your details have been updated."
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  private

    def find_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email,
                                   :password, :password_confirmation,
                                   :location, :bio)
    end
end
