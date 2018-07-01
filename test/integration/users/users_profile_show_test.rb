require 'test_helper'

class UsersProfileShowTest < ActionDispatch::IntegrationTest
  def setup
    stub_sample_content_for_new_users

    @phil    = create :user, :confirmed, :with_info, name: "Phil"
    @penny   = create :user, :confirmed, name: "Penny"
    @woodell = create :user, :confirmed, name: "Woodell"
    @group   = create :group, owner: @phil

    @group.members << [@penny, @woodell]
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

    assert_not page.has_css? ".group-points"
  end

  test "group member visits group members's profile" do
    log_in_as(@penny)

    visit group_members_path(@group)

    click_on @woodell.name

    assert page.has_css? ".group-points"
  end

  test "group member visits event attendee's profile" do
    event = create :event, group: @group
    event.attendees << @woodell

    log_in_as(@penny)

    visit event_attendees_path(event)

    click_on @woodell.name

    assert page.has_css? ".group-points"
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
