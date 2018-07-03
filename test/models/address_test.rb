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
