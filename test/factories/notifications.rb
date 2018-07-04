# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    user
    message "Factory notification."
    type    "Notification"
  end
end
