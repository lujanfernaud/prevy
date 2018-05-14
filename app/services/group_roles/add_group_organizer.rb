class AddGroupOrganizer
  def self.call(params)
    new(params).call
  end

  def initialize(params)
    @user  = params[:user]
    @group = params[:group]
  end

  def call
    if @user.has_role?(:organizer, @group)
      raise StandardError,
        "#{@user.name} is already an organizer in #{@group.name}"
    end

    @group.add_to_organizers(@user)

    notify_user unless @group.sample_group?
  end

  private

    def notify_user
      GroupRoleNotification.create(
        user: @user,
        group: @group,
        message: "You are now an organizer in #{@group.name}!"
      )

      return unless @user.group_role_emails?

      AddGroupOrganizerJob.perform_async(@user, @group)
    end
end
