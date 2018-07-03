# frozen_string_literal: true
# == Schema Information
#
# Table name: attendances
#
#  id                :bigint(8)        not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  attended_event_id :bigint(8)
#  attendee_id       :bigint(8)
#
# Indexes
#
#  index_attendances_on_attended_event_id  (attended_event_id)
#  index_attendances_on_attendee_id        (attendee_id)
#

FactoryBot.define do
  factory :attendance do
    attendee
    attended_event
  end
end
