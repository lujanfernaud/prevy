class NotificationMailer < ApplicationMailer
  default from: "notifications@vamosapp.herokuapp.com"

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

  def added_to_organizers(user, group)
    default_notification_email(
      user, group,
      subject: "You are now an organizer in #{group.name}!"
    )
  end

  def deleted_from_organizers(user, group)
    default_notification_email(
      user, group,
      subject: "You are no longer an organizer in #{group.name}"
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
end
