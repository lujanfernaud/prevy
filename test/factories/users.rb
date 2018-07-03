# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  name                   :string
#  email                  :string           default(""), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  location               :string
#  bio                    :string
#  settings               :jsonb            not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  sample_user            :boolean          default(FALSE)
#  admin                  :boolean          default(FALSE)
#  slug                   :string
#


FactoryBot.define do
  factory :user, aliases: [:owner, :organizer, :attendee] do
    sequence(:name)  { |n| "Factory User #{n}" }
    sequence(:email) { |n| "factoryuser#{n}@test.test" }
    password         "password"

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
