# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer

class NotificationMailerPreview < ActionMailer::Preview
  def new_membership_request
    NotificationMailer.new_membership_request(User.last, Group.last)
  end

  def declined_membership_request
    NotificationMailer.declined_membership_request(User.last, Group.last)
  end

  def new_group_membership
    NotificationMailer.new_group_membership(User.last, Group.last)
  end

  def deleted_group_membership
    NotificationMailer.deleted_group_membership(User.last, Group.last)
  end

  def new_event
    NotificationMailer.new_event(User.last, Group.last, Event.last)
  end

  def updated_event
    updated_data = ["start date", "end date", "event address"]

    NotificationMailer.updated_event(User.last, Event.last, updated_data)
  end
end
