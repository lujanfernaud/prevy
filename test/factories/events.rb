# frozen_string_literal: true

FactoryBot.define do
  factory :event do
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
