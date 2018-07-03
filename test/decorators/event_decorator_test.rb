# frozen_string_literal: true

require 'test_helper'

class EventDecoratorTest < ActiveSupport::TestCase
  def setup
    stub_requests_to_googleapis
  end

  test "#full_address returns full address without country" do
    event = fake_event_decorator
    full_address = "Obento, Matsubara-dori, 8, Kyoto, 6050856"

    assert_equal event.full_address, full_address
  end

  test "#short_address returns place name and city" do
    event = fake_event_decorator
    short_address = "Obento, Kyoto"

    assert_equal event.short_address, short_address
  end

  test "#website_prettyfied" do
    event = fake_event_decorator(website: "https://www.testwebsite.com")
    expected = "www.testwebsite.com"

    assert_equal expected, event.website_prettyfied
  end

  private

    def fake_event_decorator(params = {})
      @fake_event_decorator ||= EventDecorator.new(fake_event(params))
    end
end
