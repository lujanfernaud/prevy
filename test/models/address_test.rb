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

require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  def setup
    stub_geocoder
  end

  test "#full_address_changed?" do
    event = fake_event
    event.save
    address = event.address

    refute address.full_address_changed?

    address.city = "Santa Cruz de Tenerife"

    assert address.full_address_changed?
  end
end
