class Groups::MembershipRequestsController < ApplicationController
  def new
    @membership_request = MembershipRequest.new
    @group = find_group

    authorize @membership_request
  end

  def create
    @user  = current_user
    @group = find_group
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
    @membership_request = find_membership_request
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

    def find_membership_request
      MembershipRequest.find(params[:id])
    end

    def find_group
      Group.find(params[:group_id])
    end

    def membership_request_params
      params.require(:membership_request).permit(:message)
    end

    def notify_group_owner
      NewMembershipRequest.call(@membership_request)
    end

    def notify_requester
      DeclinedMembershipRequest.call(@membership_request)
    end

    def user_not_authorized
      redirect_to new_user_registration_path
    end
end
