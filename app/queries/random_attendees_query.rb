# frozen_string_literal: true

class RandomAttendeesQuery
  def self.call(event, limit)
    new(event, limit).call
  end

  def initialize(event, limit)
    @attendees       = event.attendees
    @attendees_count = event.attendees_count
    @limit           = limit
  end

  def call
    return attendees unless attendees_count > limit

    random_offset = rand(attendees_count - limit)

    attendees.offset(random_offset).limit(limit).shuffle
  end

  private

    attr_reader :attendees, :attendees_count, :limit
end
