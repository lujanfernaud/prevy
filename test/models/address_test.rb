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
