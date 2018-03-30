class DeleteGroupOrganizer
  def self.call(params)
    new(params).call
  end

  def initialize(params)
    @user  = params[:user]
    @group = params[:group]
  end

  def call
    if !@user.has_role?(:organizer, @group)
      raise StandardError,
        "#{@user.name} is not an organizer in #{@group.name}"
    end

    @user.remove_role :organizer, @group
    @user.add_role    :member, @group

    notify_user
  end

  private

    def notify_user
      GroupRoleNotification.create(
        user: @user,
        group: @group,
        message: "You are no longer an organizer in #{@group.name}."
      )

      return unless @user.group_role_emails?

      DeleteGroupOrganizerJob.perform_async(@user, @group)
    end
end
