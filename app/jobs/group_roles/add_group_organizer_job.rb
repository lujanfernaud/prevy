class AddGroupOrganizerJob < ApplicationJob
  def perform(user, group)
    NotificationMailer.added_to_organizers(user, group).deliver_now
  end
end
