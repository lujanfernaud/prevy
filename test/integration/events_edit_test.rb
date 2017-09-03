require 'test_helper'

class EventsUpdateTest < ActionDispatch::IntegrationTest
  def setup
    @user  = users(:phil)
    @event = events(:one)
  end

  test "update event with valid title" do
    visit_edit_event_path

    fill_in "Title",           with: @event.title
    fill_in "Description",     with: @event.description
    fill_in "datetimepicker1", with: @event.start_date
    fill_in "datetimepicker2", with: @event.end_date

    click_on_update_event
    assert_valid
  end

  test "update event with valid description" do
    visit_edit_event_path

    fill_in "Title",           with: @event.title
    fill_in "Description",     with: Faker::Lorem.paragraph
    fill_in "datetimepicker1", with: @event.start_date
    fill_in "datetimepicker2", with: @event.end_date

    click_on_update_event
    assert_valid
  end

  test "update event with valid date" do
    visit_edit_event_path

    fill_in "Title",           with: @event.title
    fill_in "Description",     with: @event.description
    fill_in "datetimepicker1", with: @event.start_date + 1.day
    fill_in "datetimepicker2", with: @event.end_date + 1.day

    click_on_update_event
    assert_valid
  end

  test "update event with invalid start date" do
    visit_edit_event_path

    fill_in "Title",           with: @event.title
    fill_in "Description",     with: @event.description
    fill_in "datetimepicker1", with: 1.week.ago
    fill_in "datetimepicker2", with: @event.end_date + 1.day

    click_on_update_event
    assert_invalid
  end

  test "update event with empty start date" do
    visit_edit_event_path

    fill_in "Title",           with: @event.title
    fill_in "Description",     with: @event.description
    fill_in "datetimepicker1", with: nil
    fill_in "datetimepicker2", with: @event.end_date + 1.day

    click_on_update_event
    assert_invalid
  end

  test "update event with invalid end date" do
    visit_edit_event_path

    fill_in "Title",           with: @event.title
    fill_in "Description",     with: @event.description
    fill_in "datetimepicker1", with: @event.start_date + 1.day
    fill_in "datetimepicker2", with: 1.year.ago

    click_on_update_event
    assert_invalid
  end

  test "update event with empty end date" do
    visit_edit_event_path

    fill_in "Title",           with: @event.title
    fill_in "Description",     with: @event.description
    fill_in "datetimepicker1", with: @event.start_date + 1.day
    fill_in "datetimepicker2", with: nil

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
