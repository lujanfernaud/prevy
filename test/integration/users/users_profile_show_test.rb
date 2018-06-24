require 'test_helper'

class UsersProfileShowTest < ActionDispatch::IntegrationTest
  def setup
    @phil    = users(:phil)
    @penny   = users(:penny)
    @woodell = users(:woodell)
    @group   = groups(:one)

    add_members_to_group(@group, @penny, @woodell)
  end

  test "user visits someone's profile" do
    log_in_as(@penny)

    visit user_path(@phil)

    assert page.has_content? @phil.name
    assert page.has_css?     ".user-avatar"

    assert page.has_content? "Location"
    assert page.has_content? @phil.location

    assert page.has_content? "Bio"
    assert page.has_content? @phil.bio

    assert_not page.has_css? ".comments-count"
  end

  test "group member visits group members's profile" do
    log_in_as(@penny)

    visit group_members_path(@group)

    click_on @woodell.name

    assert page.has_css? ".comments-count"
  end

  test "group member visits event attendee's profile" do
    event = events(:one)
    attendee = event.attendees.first

    log_in_as(@penny)

    visit event_attendances_path(event)

    click_on attendee.name

    assert page.has_css? ".comments-count"
  end

  test "profile shows edit link for logged in user" do
    log_in_as(@phil)

    visit user_path(@phil)

    assert page.has_content? "Edit profile"
  end

  test "profile does not show edit link for other users" do
    log_in_as(@phil)

    visit user_path(@penny)

    assert_not page.has_content? "Edit profile"
  end
end
