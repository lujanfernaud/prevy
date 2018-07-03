# frozen_string_literal: true

# == Schema Information
#
# Table name: addresses
#
#  id         :bigint(8)        not null, primary key
#  event_id   :bigint(8)
#  place_name :string
#  street1    :string
#  street2    :string
#  city       :string
#  state      :string
#  post_code  :string
#  country    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  latitude   :float
#  longitude  :float
#


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
