# frozen_string_literal: true

class NewEventNotifier
  def self.call(event)
    new(event).call
  end

  def initialize(event)
    @event = event
    @group = event.group
  end

  def call
    @group.members.each do |member|
      next unless member.group_event_emails?

      NotificationMailer.new_event(member, @group, @event).deliver_later
    end
  end
end
