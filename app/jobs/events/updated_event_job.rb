class UpdatedEventJob < ApplicationJob
  def perform(user, event, updated_data)
    NotificationMailer.updated_event(user, event, updated_data).deliver_now
  end
end
