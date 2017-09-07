require 'test_helper'

class EventsCreationTest < ActionDispatch::IntegrationTest
  def setup
    @user  = users(:phil)
    @event = events(:one)
  end

  test "create event with valid data" do
    visit_new_event_path

    fill_in "Title",           with: @event.title
    fill_in "Description",     with: @event.description
    select_date_and_time @event.start_date, from: "event_start_date"
    select_date_and_time @event.end_date,   from: "event_end_date"
    attach_file "event_image", "test/fixtures/files/sample.jpeg"

    click_on_create_event
    assert_valid
  end

  test "create event with invalid title" do
    visit_new_event_path

    fill_in "Title",           with: "T"
    fill_in "Description",     with: @event.description
    select_date_and_time @event.start_date, from: "event_start_date"
    select_date_and_time @event.end_date,   from: "event_end_date"
    attach_file "event_image", "test/fixtures/files/sample.jpeg"

    click_on_create_event
    assert_invalid
  end

  test "create event with invalid description" do
    visit_new_event_path

    fill_in "Title",           with: @event.title
    fill_in "Description",     with: "Too short description."
    select_date_and_time @event.start_date, from: "event_start_date"
    select_date_and_time @event.end_date,   from: "event_end_date"
    attach_file "event_image", "test/fixtures/files/sample.jpeg"

    click_on_create_event
    assert_invalid
  end

  test "create event with start date in the past" do
    visit_new_event_path

    fill_in "Title",           with: @event.title
    fill_in "Description",     with: @event.description
    select_date_and_time 1.week.ago,      from: "event_start_date"
    select_date_and_time @event.end_date, from: "event_end_date"
    attach_file "event_image", "test/fixtures/files/sample.jpeg"

    click_on_create_event
    assert_invalid
  end

  test "create event with end date earlier than start date" do
    visit_new_event_path

    fill_in "Title",           with: @event.title
    fill_in "Description",     with: @event.description
    select_date_and_time @event.start_date, from: "event_start_date"
    select_date_and_time 1.week.ago,        from: "event_end_date"
    attach_file "event_image", "test/fixtures/files/sample.jpeg"

    click_on_create_event
    assert_invalid
  end

  test "create event without start date" do
    visit_new_event_path

    fill_in "Title",           with: @event.title
    fill_in "Description",     with: @event.description
    select_date_and_time nil,             from: "event_start_date"
    select_date_and_time @event.end_date, from: "event_end_date"
    attach_file "event_image", "test/fixtures/files/sample.jpeg"

    click_on_create_event
    assert_invalid
  end

  test "create event without end date" do
    visit_new_event_path

    fill_in "Title",           with: @event.title
    fill_in "Description",     with: @event.description
    select_date_and_time @event.start_date, from: "event_start_date"
    select_date_and_time nil,               from: "event_end_date"
    attach_file "event_image", "test/fixtures/files/sample.jpeg"

    click_on_create_event
    assert_invalid
  end

  test "create event without image" do
    visit_new_event_path

    fill_in "Title",           with: @event.title
    fill_in "Description",     with: @event.description
    select_date_and_time @event.start_date, from: "event_start_date"
    select_date_and_time @event.end_date,   from: "event_end_date"

    click_on_create_event
    assert_invalid
  end

  private

    def visit_new_event_path
      log_in_as(@user)
      visit new_event_path
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
