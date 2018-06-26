# frozen_string_literal: true

# Used to authorize attendee in Groups::AttendeesController.
class Attendee
  attr_reader :event, :group

  def initialize(user, event)
    @user  = user
    @event = event
    @group = @event.group
  end
end
