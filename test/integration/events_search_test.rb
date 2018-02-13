require 'test_helper'

class EventsSearchTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:penny)
  end

  test "user can search for an event using only the city" do
    log_in_as(@user)
    visit root_path

    fill_in "City", with: "Kyoto"
    fill_in "Event", with: ""
    click_on "Search"

    assert page.has_content? "2 events found"

    fill_in "City", with: "Osaka"
    fill_in "Event", with: ""
    click_on "Search"

    assert page.has_content? "22 events found"
  end

  test "user can search for an event using only the event's name" do
    log_in_as(@user)
    visit root_path

    fill_in "City", with: ""
    fill_in "Event", with: "Hatsumode"
    click_on "Search"

    assert page.has_content? "1 event found"

    fill_in "City", with: ""
    fill_in "Event", with: "Test event"
    click_on "Search"

    assert page.has_content? "23 events found"
  end

  test "user can search for an event using the city and event's name" do
    log_in_as(@user)
    visit root_path

    fill_in "City", with: "Tokyo"
    fill_in "Event", with: "Test"
    click_on "Search"

    assert page.has_content? "1 event found"
  end

  test "user can search for an event using a partial string" do
    log_in_as(@user)
    visit root_path

    fill_in "City", with: "Tok"
    fill_in "Event", with: "Test"
    click_on "Search"

    assert page.has_content? "1 event found"

    fill_in "City", with: "saka"
    fill_in "Event", with: ""
    click_on "Search"

    assert page.has_content? "22 events found"
  end

  test "user can search in a different case" do
    log_in_as(@user)
    visit root_path

    fill_in "City", with: ""
    fill_in "Event", with: "hatsumode"
    click_on "Search"

    assert page.has_content? "1 event found"

    fill_in "City", with: ""
    fill_in "Event", with: "HATSUMODE"
    click_on "Search"

    assert page.has_content? "1 event found"
  end
end
