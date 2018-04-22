require 'test_helper'

class EventsCreationTest < ActionDispatch::IntegrationTest
  def setup
    stub_geocoder

    @user    = users(:phil)
    @group   = groups(:one)
    @event   = events(:one)
    @address = addresses(:one)
    @event.build_address(@address.attributes)

    @user.add_role(:organizer, @group)
  end

  test "create event with valid data" do
    prepare_javascript_driver

    log_in_as(@user)
    visit group_path(@group)

    within ".group-info-box" do
      click_on "Create event"
    end

    fill_in_valid_information(@event.description)
    fill_in_valid_address
    fill_in_valid_dates
    attach_valid_image_for "event_image"

    click_on_create_event
    assert_valid

    teardown
  end

  test "create event with invalid title" do
    log_in_as(@user)
    visit group_path(@group)

    within ".group-info-box" do
      click_on "Create event"
    end

    fill_in "Title", with: "T"
    fill_in_description(@event.description)

    fill_in_valid_address
    fill_in_valid_dates
    attach_valid_image_for "event_image"

    click_on_create_event
    assert_invalid
  end

  test "create event with invalid description" do
    log_in_as(@user)
    visit group_path(@group)

    within ".group-info-box" do
      click_on "Create event"
    end

    fill_in "Title", with: @event.title
    fill_in_description("Too short description.")

    fill_in_valid_address
    fill_in_valid_dates
    attach_valid_image_for "event_image"

    click_on_create_event
    assert_invalid
  end

  test "create event with missing street" do
    log_in_as(@user)
    visit group_path(@group)

    within ".group-info-box" do
      click_on "Create event"
    end

    fill_in_valid_information(@event.description)

    fill_in "Address 1", with: ""
    fill_in "Address 2", with: @event.street2
    fill_in "City",      with: @event.city
    fill_in "State",     with: @event.state
    fill_in "Post code", with: @event.post_code
    select  "Spain",     from: "Country"

    fill_in_valid_dates
    attach_valid_image_for "event_image"

    click_on_create_event
    assert_invalid
  end

  test "create event with missing city" do
    log_in_as(@user)
    visit group_path(@group)

    within ".group-info-box" do
      click_on "Create event"
    end

    fill_in_valid_information(@event.description)

    fill_in "Address 1", with: @event.street1
    fill_in "Address 2", with: @event.street2
    fill_in "City",      with: ""
    fill_in "State",     with: @event.state
    fill_in "Post code", with: @event.post_code
    select  "Spain",     from: "Country"

    fill_in_valid_dates
    attach_valid_image_for "event_image"

    click_on_create_event
    assert_invalid
  end

  test "create event with missing post code" do
    log_in_as(@user)
    visit group_path(@group)

    within ".group-info-box" do
      click_on "Create event"
    end

    fill_in_valid_information(@event.description)

    fill_in "Address 1", with: @event.street1
    fill_in "Address 2", with: @event.street2
    fill_in "City",      with: @event.city
    fill_in "State",     with: @event.state
    fill_in "Post code", with: ""
    select  "Spain",     from: "Country"

    fill_in_valid_dates
    attach_valid_image_for "event_image"

    click_on_create_event
    assert_invalid
  end

  test "create event with missing country" do
    log_in_as(@user)
    visit group_path(@group)

    within ".group-info-box" do
      click_on "Create event"
    end

    fill_in_valid_information(@event.description)

    fill_in "Address 1", with: @event.street1
    fill_in "Address 2", with: @event.street2
    fill_in "City",      with: @event.state
    fill_in "Post code", with: @event.post_code
    select  "",          from: "Country"

    fill_in_valid_dates
    attach_valid_image_for "event_image"

    click_on_create_event
    assert_invalid
  end

  test "create event with start date in the past" do
    log_in_as(@user)
    visit group_path(@group)

    within ".group-info-box" do
      click_on "Create event"
    end

    fill_in_valid_information(@event.description)
    fill_in_valid_address

    select_date_and_time 1.week.ago,      from: "event_start_date"
    select_date_and_time @event.end_date, from: "event_end_date"

    attach_valid_image_for "event_image"

    click_on_create_event
    assert_invalid
  end

  test "create event with end date earlier than start date" do
    log_in_as(@user)
    visit group_path(@group)

    within ".group-info-box" do
      click_on "Create event"
    end

    fill_in_valid_information(@event.description)
    fill_in_valid_address

    select_date_and_time @event.start_date, from: "event_start_date"
    select_date_and_time 1.week.ago,        from: "event_end_date"

    attach_valid_image_for "event_image"

    click_on_create_event
    assert_invalid
  end

  test "create event without start date" do
    log_in_as(@user)
    visit group_path(@group)

    within ".group-info-box" do
      click_on "Create event"
    end

    fill_in_valid_information(@event.description)
    fill_in_valid_address

    select_date_and_time nil,             from: "event_start_date"
    select_date_and_time @event.end_date, from: "event_end_date"

    attach_valid_image_for "event_image"

    click_on_create_event
    assert_invalid
  end

  test "create event without end date" do
    log_in_as(@user)
    visit group_path(@group)

    within ".group-info-box" do
      click_on "Create event"
    end

    fill_in_valid_information(@event.description)
    fill_in_valid_address

    select_date_and_time @event.start_date, from: "event_start_date"
    select_date_and_time nil,               from: "event_end_date"

    attach_valid_image_for "event_image"

    click_on_create_event
    assert_invalid
  end

  test "create event without image" do
    log_in_as(@user)
    visit group_path(@group)

    within ".group-info-box" do
      click_on "Create event"
    end

    fill_in_valid_information(@event.description)
    fill_in_valid_address
    fill_in_valid_dates

    click_on_create_event
    assert_invalid
  end

  private

    def fill_in_valid_information(event_description)
      fill_in "Title", with: @event.title
      fill_in_description(event_description)
    end

    def fill_in_valid_address
      fill_in "Address 1", with: @event.street1
      fill_in "Address 2", with: @event.street2
      fill_in "City",      with: @event.city
      fill_in "State",     with: @event.state
      fill_in "Post code", with: @event.post_code
      select  "Spain",     from: "Country"
    end

    def fill_in_valid_dates
      select_date_and_time @event.start_date, from: "event_start_date"
      select_date_and_time @event.end_date,   from: "event_end_date"
    end

    def click_on_create_event
      within "form" do
        click_on "Create event"
      end
    end

    def assert_valid
      assert current_path, group_event_path(@group, @event)
      assert page.has_content? "created"
    end

    def assert_invalid
      assert current_path, new_group_event_path(@group)
      assert page.has_content? "error"
    end
end
