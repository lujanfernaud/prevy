# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id             :bigint(8)        not null, primary key
#  title          :string
#  description    :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  organizer_id   :bigint(8)
#  start_date     :datetime
#  end_date       :datetime
#  image          :string
#  website        :string
#  group_id       :bigint(8)
#  updated_fields :jsonb            not null
#  sample_event   :boolean          default(FALSE)
#  slug           :string
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
