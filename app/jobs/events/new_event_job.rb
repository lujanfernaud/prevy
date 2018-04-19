class NewEventJob < ApplicationJob
  def perform(user, group, event)
    NotificationMailer.new_event(user, group, event).deliver_now
  end
end
