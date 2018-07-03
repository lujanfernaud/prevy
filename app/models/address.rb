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

class Address < ApplicationRecord
  belongs_to :event

  validates  :city,      presence: true
  validates  :country,   presence: true
  validates  :post_code, presence: true
  validates  :street1,   presence: true

  # Geocoder
  geocoded_by      :full_address
  after_validation :geocode, if: :full_address_changed?

  def full_address
    attributes = [place_name, street1, street2, city, state, post_code]

    attributes.reject(&:blank?).map(&:strip).join(", ")
  end

  def full_address_changed?
    !changed.empty?
  end
end
