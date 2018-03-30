class DeleteGroupOrganizerJob < ApplicationJob
  def perform(user, group)
    NotificationMailer.deleted_from_organizers(user, group).deliver_now
  end
end
