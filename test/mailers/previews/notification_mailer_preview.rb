# frozen_string_literal: true

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

  def added_group_role
    NotificationMailer.added_group_role(User.last, Group.last)
  end

  def deleted_group_role
    NotificationMailer.deleted_group_role(User.last, Group.last)
  end

  def new_event
    NotificationMailer.new_event(User.last, Group.last, Event.last)
  end

  def updated_event
    updated_data = ["start date", "end date", "event address"]

    NotificationMailer.updated_event(User.last, Event.last, updated_data)
  end

  def new_announcement_topic
    NotificationMailer.new_announcement_topic(user, announcement_topic)
  end

  private

    def user
      group.members.first
    end

    def group
      Group.first
    end

    def announcement_topic
      return last_announcement_topic if last_announcement_topic_exists?

      AnnouncementTopic.create!(
        user:  user,
        group: group,
        title: "Sample Announcement Topic",
        body:  "Body of sample announcement topic."
      )
    end

    def last_announcement_topic
      group.announcement_topics.last
    end

    def last_announcement_topic_exists?
      !group.announcement_topics.empty?
    end
end
