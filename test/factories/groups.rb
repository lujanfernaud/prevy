# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    owner
    sequence(:name) { |n| "Test Group #{n}" }
    location        "Tenerife"
    description     { Faker::Lorem.paragraph * 2 }
    image           { Rack::Test::UploadedFile.new("#{Rails.root}/test/fixtures/files/sample.jpg", "image/jpeg") }
  end
end
