require 'test_helper'

class EventsUpdateTest < ActionDispatch::IntegrationTest
  def setup
    stub_geocoder

    @user  = users(:phil)
    @group = groups(:one)
    @event = events(:one)
  end

  test "update event with valid title" do
    visit_edit_group_event_path

    fill_in "Title", with: @event.title
    find("trix-editor").click.set(@event.description)
    select "Japan", from: "Country"
    select_date_and_time @event.start_date, from: "event_start_date"
    select_date_and_time @event.end_date,   from: "event_end_date"
    attach_valid_image_for "event_image"

    click_on_update_event
    assert_valid
  end

  test "update event with valid description" do
    visit_edit_group_event_path

    fill_in "Title", with: @event.title
    find("trix-editor").click.set(Faker::Lorem.paragraph)
    select "Japan", from: "Country"
    select_date_and_time @event.start_date, from: "event_start_date"
    select_date_and_time @event.end_date,   from: "event_end_date"
    attach_valid_image_for "event_image"

    click_on_update_event
    assert_valid
  end

  test "update event with valid date" do
    visit_edit_group_event_path

    fill_in "Title", with: @event.title
    find("trix-editor").click.set(@event.description)
    select "Japan", from: "Country"
    select_date_and_time @event.start_date + 1.day, from: "event_start_date"
    select_date_and_time @event.end_date + 1.day,   from: "event_end_date"
    attach_valid_image_for "event_image"

    click_on_update_event
    assert_valid
  end

  test "update event with invalid start date" do
    visit_edit_group_event_path

    fill_in "Title", with: @event.title
    find("trix-editor").click.set(@event.description)
    select_date_and_time 1.week.ago,              from: "event_start_date"
    select_date_and_time @event.end_date + 1.day, from: "event_end_date"
    attach_valid_image_for "event_image"

    click_on_update_event
    assert_invalid
  end

  test "update event with invalid end date" do
    visit_edit_group_event_path

    fill_in "Title", with: @event.title
    find("trix-editor").click.set(@event.description)
    select_date_and_time @event.start_date, from: "event_start_date"
    select_date_and_time 1.week.ago,        from: "event_end_date"
    attach_valid_image_for "event_image"

    click_on_update_event
    assert_invalid
  end

  test "event page has delete button" do
    visit_edit_group_event_path

    assert page.has_link? "Delete event"
  end

  private

    def visit_edit_group_event_path
      log_in_as(@user)
      visit edit_group_event_path(@group, @event)
    end

    def click_on_update_event
      within "form" do
        click_on "Update event"
      end
    end

    def assert_valid
      assert current_path, group_event_path(@group, @event)
      assert page.has_content? "updated"
    end

    def assert_invalid
      assert current_path, edit_group_event_path(@group, @event)
      assert page.has_content? "error"
    end
end
