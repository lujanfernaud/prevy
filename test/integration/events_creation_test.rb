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
    fill_in "datetimepicker1", with: @event.start_date
    fill_in "datetimepicker2", with: @event.end_date

    click_on_create_event
    assert_valid
  end

  test "create event with invalid title" do
    visit_new_event_path

    fill_in "Title",           with: "T"
    fill_in "Description",     with: @event.description
    fill_in "datetimepicker1", with: @event.start_date
    fill_in "datetimepicker2", with: @event.end_date

    click_on_create_event
    assert_invalid
  end

  test "create event with invalid description" do
    visit_new_event_path

    fill_in "Title",           with: @event.title
    fill_in "Description",     with: "Too short description."
    fill_in "datetimepicker1", with: @event.start_date
    fill_in "datetimepicker2", with: @event.end_date

    click_on_create_event
    assert_invalid
  end

  test "create event with start date in the past" do
    visit_new_event_path

    fill_in "Title",           with: @event.title
    fill_in "Description",     with: @event.description
    fill_in "datetimepicker1", with: 1.week.ago
    fill_in "datetimepicker2", with: @event.end_date

    click_on_create_event
    assert_invalid
  end

  test "create event with end date earlier than start date" do
    visit_new_event_path

    fill_in "Title",           with: @event.title
    fill_in "Description",     with: @event.description
    fill_in "datetimepicker1", with: @event.start_date
    fill_in "datetimepicker2", with: 1.week.ago

    click_on_create_event
    assert_invalid
  end

  test "create event without start date" do
    visit_new_event_path

    fill_in "Title",           with: @event.title
    fill_in "Description",     with: @event.description
    fill_in "datetimepicker1", with: nil
    fill_in "datetimepicker2", with: @event.end_date

    click_on_create_event
    assert_invalid
  end

  test "create event without end date" do
    visit_new_event_path

    fill_in "Title",           with: @event.title
    fill_in "Description",     with: @event.description
    fill_in "datetimepicker1", with: @event.start_date
    fill_in "datetimepicker2", with: nil

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
