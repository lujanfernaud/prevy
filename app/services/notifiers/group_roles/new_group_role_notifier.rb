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
    if user.has_role?(role.to_sym, group)
      raise StandardError,
        "#{user.name} already has #{role} role in #{group.name}"
    end

    group.public_send("add_to_#{role.pluralize}", user)

    notify_user unless group.sample_group?
  end

  private

    attr_reader :user, :group, :role

    def notify_user
      GroupRoleNotification.create(
        user: user,
        group: group,
        message: "You now have #{role} role in #{group.name}!"
      )

      return unless user.group_role_emails?

      AddGroupRoleJob.perform_async(user, group, role)
    end
end
