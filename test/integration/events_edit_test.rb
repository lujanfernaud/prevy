require 'test_helper'

class EventsUpdateTest < ActionDispatch::IntegrationTest
  def setup
    @user    = users(:phil)
    @event   = events(:one)
    @address = addresses(:one)
    @event.build_address(@address.attributes)
  end

  test "update event with valid title" do
    visit_edit_event_path

    fill_in "Title",           with: @event.title
    fill_in "Description",     with: @event.description
    select_date_and_time @event.start_date, from: "event_start_date"
    select_date_and_time @event.end_date,   from: "event_end_date"
    attach_file "event_image", "test/fixtures/files/sample.jpeg"

    click_on_update_event
    assert_valid
  end

  test "update event with valid description" do
    visit_edit_event_path

    fill_in "Title",           with: @event.title
    fill_in "Description",     with: Faker::Lorem.paragraph
    select_date_and_time @event.start_date, from: "event_start_date"
    select_date_and_time @event.end_date,   from: "event_end_date"
    attach_file "event_image", "test/fixtures/files/sample.jpeg"

    click_on_update_event
    assert_valid
  end

  test "update event with valid date" do
    visit_edit_event_path

    fill_in "Title",           with: @event.title
    fill_in "Description",     with: @event.description
    select_date_and_time @event.start_date + 1.day, from: "event_start_date"
    select_date_and_time @event.end_date + 1.day,   from: "event_end_date"
    attach_file "event_image", "test/fixtures/files/sample.jpeg"

    click_on_update_event
    assert_valid
  end

  test "update event with invalid start date" do
    visit_edit_event_path

    fill_in "Title",           with: @event.title
    fill_in "Description",     with: @event.description
    select_date_and_time 1.week.ago,              from: "event_start_date"
    select_date_and_time @event.end_date + 1.day, from: "event_end_date"
    attach_file "event_image", "test/fixtures/files/sample.jpeg"

    click_on_update_event
    assert_invalid
  end

  test "update event with invalid end date" do
    visit_edit_event_path

    fill_in "Title",           with: @event.title
    fill_in "Description",     with: @event.description
    select_date_and_time @event.start_date, from: "event_start_date"
    select_date_and_time 1.week.ago,        from: "event_end_date"
    attach_file "event_image", "test/fixtures/files/sample.jpeg"

    click_on_update_event
    assert_invalid
  end

  private

    def visit_edit_event_path
      log_in_as(@user)
      visit edit_event_path(@event)
    end

    def click_on_update_event
      within "form" do
        click_on "Update event"
      end
    end

    def assert_valid
      assert current_path, event_path(@event)
      assert page.has_content? "updated"
    end

    def assert_invalid
      assert current_path, edit_event_path(@event)
      assert page.has_content? "error"
    end
end
