# frozen_string_literal: true
# == Schema Information
#
# Table name: events
#
#  id             :bigint(8)        not null, primary key
#  description    :string
#  end_date       :datetime
#  image          :string
#  sample_event   :boolean          default(FALSE)
#  slug           :string
#  start_date     :datetime
#  title          :string
#  updated_fields :jsonb            not null
#  website        :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  group_id       :bigint(8)
#  organizer_id   :bigint(8)
#
# Indexes
#
#  index_events_on_group_id      (group_id)
#  index_events_on_organizer_id  (organizer_id)
#  index_events_on_slug          (slug)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#

FactoryBot.define do
  factory :event, aliases: [:attended_event] do
    group
    organizer
    sequence(:title) { |n| "Test Event #{n}" }
    description      { Faker::Lorem.paragraph * 2 }
    website          ""
    start_date       { Time.current + 6.days }
    end_date         { Time.current + 7.days }
    image            { Rack::Test::UploadedFile.new("#{Rails.root}/test/fixtures/files/sample.jpg", "image/jpeg") }
  end
end
