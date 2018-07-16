# frozen_string_literal: true

require 'test_helper'

class WebsiteUrlFormatterTest < ActiveSupport::TestCase
  test "adds protocol to event's website before saving if missing" do
    stub_sample_content_for_new_users

    event = create :event, website: "www.eventwebsite.com"

    assert_equal event.website, "https://" + "www.eventwebsite.com"
  end

  test "recognizes http protocol" do
    stub_sample_content_for_new_users

    event = create :event, website: "http://www.eventwebsite.com"

    assert_equal event.website, "http://www.eventwebsite.com"
  end

  test "recognizes https protocol" do
    stub_sample_content_for_new_users

    event = create :event, website: "https://www.eventwebsite.com"

    assert_equal event.website, "https://www.eventwebsite.com"
  end
end
