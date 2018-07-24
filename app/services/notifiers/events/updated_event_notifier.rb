# frozen_string_literal: true

class UpdatedEventNotifier
  def self.call(event)
    new(event).call
  end

  def initialize(event)
    @event = event
  end

  def call
    return if no_updated_fields?

    attendees.each do |attendee|
      next unless attendee.group_event_emails?

      send_email_to attendee
    end
  end

  private

    def no_updated_fields?
      @event.updated_fields.empty?
    end

    def attendees
      @event.attendees
    end

    def send_email_to(attendee)
      NotificationMailer.updated_event(attendee, @event, updated_data)
                        .deliver_later
    end

    def updated_data
      @_updated_data ||= @event.updated_fields.keys.map do |field_name|
        simplified_name_for field_name
      end
    end

    def simplified_name_for(field_name)
      field_name.remove("updated").gsub("_", " ")
    end
end
