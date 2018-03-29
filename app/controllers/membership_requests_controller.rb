class MembershipRequestsController < ApplicationController
  def index
    @user   = params[:user_id]
    @groups = Group.where(owner: @user)

    @membership_requests_received = MembershipRequest.where(group: @groups)
    @membership_requests_sent     = MembershipRequest.where(user: @user)
  end

  def show
    @user = current_user
    @membership_request = MembershipRequest.find(params[:id])
  end

  def new
    @group = Group.find(params[:group_id])
    @membership_request = MembershipRequest.new
  end

  def create
    @user  = current_user
    @group = Group.find(params[:group_id])
    @membership_request = MembershipRequest.new(
      { user: @user, group: @group }.merge(membership_request_params))

    if @membership_request.save
      flash[:success] = "Your request has been sent. " \
                        "You'll be notified when there's any change."
      notify_group_owner
      redirect_to group_path(@group)
    else
      flash[:alert] = "There was a problem. Please try again."
      render :new
    end
  end

  def destroy
    @membership_request = MembershipRequest.find(params[:id])
    @user  = @membership_request.user
    @group = @membership_request.group
    @user_session = current_user

    @membership_request.destroy

    if @user_session == @user
      flash[:success] = "Your membership request was deleted."
    else
      flash[:success] = "The membership request was deleted."
      notify_requester
    end

    redirect_to user_membership_requests_path(@user)
  end

  private

    def membership_request_params
      params.require(:membership_request).permit(:message)
    end

    def notify_group_owner
      NewMembershipRequest.call(@membership_request)
    end

    def notify_requester
      DeclinedMembershipRequest.call(@membership_request)
    end
end
