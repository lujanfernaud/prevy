# frozen_string_literal: true

FactoryBot.define do
  factory :attendance do
    attendee
    attended_event
  end
end
