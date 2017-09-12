require 'test_helper'

class EventsIndexTest < ActionDispatch::IntegrationTest
  test "index shows events" do
    visit events_path

    assert page.has_css? ".box", count: 15
  end
end
