require 'test_helper'

class EventsCreationTest < ActionDispatch::IntegrationTest
  def setup
    @user    = users(:phil)
    @event   = events(:one)
    @address = addresses(:one)
    @event.build_address(@address.attributes)
  end

  test "create event with valid data" do
    visit_new_event_path

    fill_in_valid_information
    fill_in_valid_address
    fill_in_valid_dates
    attach_valid_image

    click_on_create_event
    assert_valid
  end

  test "create event with invalid title" do
    visit_new_event_path

    fill_in "Title",       with: "T"
    fill_in "Description", with: @event.description

    fill_in_valid_address
    fill_in_valid_dates
    attach_valid_image

    click_on_create_event
    assert_invalid
  end

  test "create event with invalid description" do
    visit_new_event_path

    fill_in "Title",       with: @event.title
    fill_in "Description", with: "Too short description."

    fill_in_valid_address
    fill_in_valid_dates
    attach_valid_image

    click_on_create_event
    assert_invalid
  end

  test "create event with missing street" do
    visit_new_event_path

    fill_in_valid_information

    fill_in "Address 1",   with: ""
    fill_in "Address 2",   with: @event.street2
    fill_in "City",        with: @event.city
    fill_in "State",       with: @event.state
    fill_in "Post code",   with: @event.post_code
    fill_in "Country",     with: @event.country

    fill_in_valid_dates
    attach_valid_image

    click_on_create_event
    assert_invalid
  end

  test "create event with missing city" do
    visit_new_event_path

    fill_in_valid_information

    fill_in "Address 1",   with: @event.street1
    fill_in "Address 2",   with: @event.street2
    fill_in "City",        with: ""
    fill_in "State",       with: @event.state
    fill_in "Post code",   with: @event.post_code
    fill_in "Country",     with: @event.country

    fill_in_valid_dates
    attach_valid_image

    click_on_create_event
    assert_invalid
  end

  test "create event with missing post code" do
    visit_new_event_path

    fill_in_valid_information

    fill_in "Address 1",   with: @event.street1
    fill_in "Address 2",   with: @event.street2
    fill_in "City",        with: @event.city
    fill_in "State",       with: @event.state
    fill_in "Post code",   with: ""
    fill_in "Country",     with: @event.country

    fill_in_valid_dates
    attach_valid_image

    click_on_create_event
    assert_invalid
  end

  test "create event with missing country" do
    visit_new_event_path

    fill_in_valid_information

    fill_in "Address 1",   with: @event.street1
    fill_in "Address 2",   with: @event.street2
    fill_in "City",        with: @event.city
    fill_in "State",       with: @event.state
    fill_in "Post code",   with: @event.post_code
    fill_in "Country",     with: ""

    fill_in_valid_dates
    attach_valid_image

    click_on_create_event
    assert_invalid
  end

  test "create event with start date in the past" do
    visit_new_event_path

    fill_in_valid_information
    fill_in_valid_address

    select_date_and_time 1.week.ago,      from: "event_start_date"
    select_date_and_time @event.end_date, from: "event_end_date"

    attach_valid_image

    click_on_create_event
    assert_invalid
  end

  test "create event with end date earlier than start date" do
    visit_new_event_path

    fill_in_valid_information
    fill_in_valid_address

    select_date_and_time @event.start_date, from: "event_start_date"
    select_date_and_time 1.week.ago,        from: "event_end_date"

    attach_valid_image

    click_on_create_event
    assert_invalid
  end

  test "create event without start date" do
    visit_new_event_path

    fill_in_valid_information
    fill_in_valid_address

    select_date_and_time nil,             from: "event_start_date"
    select_date_and_time @event.end_date, from: "event_end_date"

    attach_valid_image

    click_on_create_event
    assert_invalid
  end

  test "create event without end date" do
    visit_new_event_path

    fill_in_valid_information
    fill_in_valid_address

    select_date_and_time @event.start_date, from: "event_start_date"
    select_date_and_time nil,               from: "event_end_date"

    attach_valid_image

    click_on_create_event
    assert_invalid
  end

  test "create event without image" do
    visit_new_event_path

    fill_in_valid_information
    fill_in_valid_address
    fill_in_valid_dates

    click_on_create_event
    assert_invalid
  end

  private

    def visit_new_event_path
      log_in_as(@user)
      visit new_event_path
    end

    def fill_in_valid_information
      fill_in "Title",       with: @event.title
      fill_in "Description", with: @event.description
    end

    def fill_in_valid_address
      fill_in "Address 1", with: @event.street1
      fill_in "Address 2", with: @event.street2
      fill_in "City",      with: @event.city
      fill_in "State",     with: @event.state
      fill_in "Post code", with: @event.post_code
      fill_in "Country",   with: @event.country
    end

    def fill_in_valid_dates
      select_date_and_time @event.start_date, from: "event_start_date"
      select_date_and_time @event.end_date,   from: "event_end_date"
    end

    def attach_valid_image
      attach_file "event_image", "test/fixtures/files/sample.jpeg"
    end

    def click_on_create_event
      within "form" do
        click_on "Create event"
      end
    end

    def assert_valid
      assert current_path, event_path(@event)
      assert page.has_content? "created"
    end

    def assert_invalid
      assert current_path, new_event_path
      assert page.has_content? "error"
    end
end
