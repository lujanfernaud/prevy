# frozen_string_literal: true

# == Schema Information
#
# Table name: attendances
#
#  id                :bigint(8)        not null, primary key
#  attendee_id       :bigint(8)
#  attended_event_id :bigint(8)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#


FactoryBot.define do
  factory :attendance do
    attendee
    attended_event
  end
end
