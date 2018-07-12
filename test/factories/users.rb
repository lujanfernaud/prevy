# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  admin                  :boolean          default(FALSE)
#  bio                    :string
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  location               :string
#  name                   :string
#  notifications_count    :integer          default(0), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sample_user            :boolean          default(FALSE)
#  settings               :jsonb            not null
#  sign_in_count          :integer          default(0), not null
#  slug                   :string
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_slug                  (slug)
#

FactoryBot.define do
  factory :user, aliases: [:owner, :sender, :organizer, :attendee] do
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

    trait :no_emails do
      settings {
        {
          membership_request_emails: false,
          group_membership_emails:   false,
          group_role_emails:         false,
          group_event_emails:        false,
          group_announcement_emails: false,
          group_invitation_emails:   false
        }
      }
    end
  end
end
