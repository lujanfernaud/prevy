# frozen_string_literal: true

FactoryBot.define do
  factory :user, aliases: [:owner, :organizer] do
    name     { Faker::Name.first_name }
    email    { "#{name}@test.test".downcase }
    password "password"

    trait :confirmed do
      after(:build) { |user| user.confirm }
      after(:build) { |user| user.skip_confirmation_notification! }
    end

    trait :with_info do
      location "Tenerife"
      bio      "Some random bio goes here."
    end
  end
end
