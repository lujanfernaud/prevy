# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  default from: "notifications@prevy.herokuapp.com"

  def new_membership_request(user, group)
    @user  = user
    @group = group
    @owner = @group.owner
    @url   = user_notifications_url(@owner)

    mail(
      to: @owner.email,
      subject: "New membership request from #{@user.name} in #{@group.name}"
    )
  end

  def declined_membership_request(user, group)
    default_notification_email(
      user, group,
      subject: "Membership request declined"
    )
  end

  def new_group_membership(user, group)
    default_notification_email(
      user, group,
      subject: "#{group.name} membership"
    )
  end

  def deleted_group_membership(user, group)
    default_notification_email(
      user, group,
      subject: "Your #{group.name} membership was cancelled"
    )
  end

  def added_group_role(user, group, role)
    group_role_notification_email(
      user:  user,
      group: group,
      role:  role,
      subject: "You now have #{role} role in #{group.name}!"
    )
  end

  def deleted_group_role(user, group, role)
    group_role_notification_email(
      user:  user,
      group: group,
      role:  role,
      subject: "You no longer have #{role} role in #{group.name}"
    )
  end

  def new_event(user, group, event)
    @user  = user
    @event = event
    @group = group

    mail(
      to: @user.email,
      subject: "New event in #{@group.name}: #{@event.title}"
    )
  end

  def updated_event(user, event, updated_data)
    @user  = user
    @event = event
    @updated_data = updated_data

    mail(
      to: @user.email,
      subject: "Update in #{@event.title}"
    )
  end

  def new_announcement_topic(user, topic)
    @user  = user
    @topic = topic
    @group = topic.group

    mail(
      to: @user.email,
      subject: "New announcement in #{@group.name}: #{@topic.title}"
    )
  end

  def new_group_invitation(invitation)
    @sender = invitation.sender
    @name   = invitation.name
    @email  = invitation.email
    @group  = invitation.group
    @token  = invitation.token

    mail(
      to: @email,
      subject: "#{@sender.name} invites you to #{@group.name}"
    )
  end

  private

    def default_notification_email(user, group, subject:)
      @user  = user
      @group = group
      @url   = user_notifications_url(@user)

      mail(
        to: @user.email,
        subject: subject
      )
    end

    def group_role_notification_email(params)
      @user  = params[:user]
      @group = params[:group]
      @role  = params[:role]
      @url   = user_notifications_url(@user)

      mail(
        to: @user.email,
        subject: params[:subject]
      )
    end
end
