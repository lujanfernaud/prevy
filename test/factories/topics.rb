# frozen_string_literal: true

FactoryBot.define do
  factory :topic do
    group
    user
    title "Test Topic"
    body  "This is the body of the test topic."
    type  "Topic"
  end
end
