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

      NewEventJob.perform_async(member, @group, @event)
    end
  end
end
