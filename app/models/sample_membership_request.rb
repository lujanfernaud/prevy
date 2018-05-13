# A sample membership request created for every new user.
class SampleMembershipRequest

  def self.create_for_user(user)
    new(user).create_request
  end

  def initialize(user)
    @user  = user
    @group = user.sample_group
    @membership_request = nil
  end

  def create_request
    create_membership_request
    create_notification
  end

  private

    attr_reader :user, :group, :membership_request

    def create_membership_request
      @membership_request = MembershipRequest.create(
        user: sample_user,
        group: group,
        message: I18n.t("sample_membership_request.message")
      )
    end

    def create_notification
      sender = @membership_request.user

      MembershipRequestNotification.create(
        user: user,
        membership_request: @membership_request,
        message: "New membership request from #{sender.name} in #{group.name}."
      )
    end

    def sample_user
      SampleUser.all.sample
    end

end
