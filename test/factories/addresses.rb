# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    event
    street1   "Matsubara-dori, 8"
    city      "Kyoto"
    post_code 6050856
    country   "Japan"
    latitude  34.997615
    longitude 135.775637
  end
end
