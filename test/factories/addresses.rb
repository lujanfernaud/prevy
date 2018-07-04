# frozen_string_literal: true

# == Schema Information
#
# Table name: addresses
#
#  id         :bigint(8)        not null, primary key
#  city       :string
#  country    :string
#  latitude   :float
#  longitude  :float
#  place_name :string
#  post_code  :string
#  state      :string
#  street1    :string
#  street2    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :bigint(8)
#
# Indexes
#
#  index_addresses_on_event_id  (event_id)
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
