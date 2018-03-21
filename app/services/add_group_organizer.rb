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

    @user.remove_role :member, @group
    @user.add_role    :organizer, @group

    notify_user
  end

  private

    def notify_user
      GroupRoleNotification.create(
        user: @user,
        group: @group,
        message: "You are now an organizer in #{@group.name}!"
      )

      return unless @user.group_role_emails?

      NotificationMailer.added_to_organizers(@user, @group).deliver_now
    end
end
