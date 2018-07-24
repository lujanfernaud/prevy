# frozen_string_literal: true

class NewGroupRoleNotifier
  def self.call(params)
    new(params).call
  end

  def initialize(params)
    @user  = params[:user]
    @group = params[:group]
    @role  = params[:role]
  end

  def call
    GroupRoleNotification.create(
      user:    user,
      group:   group,
      message: "You now have #{role} role in #{group.name}!"
    )

    return unless user.group_role_emails?

    NotificationMailer.added_group_role(user, group, role).deliver_later
  end

  private

    attr_reader :user, :group, :role
end
