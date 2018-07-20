# frozen_string_literal: true

require 'test_helper'

class GroupsMembersTest < ActionDispatch::IntegrationTest
  def setup
    stub_sample_content_for_new_users

    @phil  = users(:phil)
    @group = groups(:one)

    add_group_owner_to_organizers(@group)
    add_members_to_group(@group, @group.members.first)

    @member = @group.members_with_role.first
  end

  test "group owner visits group members" do
    log_in_as @phil

    visit group_members_path(@group)

    assert page.has_css? ".user-box"
  end

  test "member visits group members" do
    log_in_as @member

    visit group_members_path(@group)

    assert page.has_css? ".user-box"
  end

  test "unconfirmed members are not shown" do
    stub_sample_content_for_new_users

    user        = create :user, :confirmed
    unconfirmed = create :user
    group       = create :group
    group.members << [user, unconfirmed]

    log_in_as user

    visit group_members_path(group)

    assert_not page.has_content? unconfirmed.name
  end

  test "unconfirmed organizers are shown" do
    stub_sample_content_for_new_users

    user        = create :user, :confirmed
    unconfirmed = create :user
    group       = create :group
    group.members << [user, unconfirmed]

    group.add_to_organizers unconfirmed

    log_in_as user

    visit group_members_path(group)

    assert page.has_content? unconfirmed.name
  end

  test "logged out invited user visits group members" do
    invitation = create :group_invitation,
                         group:  @group,
                         sender: @group.owner,
                         email:  "test@test.test"

    visit group_path(@group, token: invitation.token)
    visit group_members_path(@group)

    assert_current_path group_members_path(@group)
  end

  test "logged in invited user visits group members" do
    user = create :user

    invitation = create :group_invitation,
                         group:  @group,
                         sender: @group.owner,
                         email:  user.email

    log_in_as user

    visit group_path(@group, token: invitation.token)
    visit group_members_path(@group)

    assert_current_path group_members_path(@group)
  end

  test "non-member user visits members" do
    user = create :user

    log_in_as user

    visit group_members_path(@group)

    assert_current_path root_path
  end

  test "logged out user visits members" do
    visit group_members_path(@group)

    assert_current_path new_user_session_path
  end

  test "member card shows points number" do
    member_group_points = @member.group_points_amount(@group)

    log_in_as @phil

    visit group_members_path(@group)

    within "#user-#{@member.id}" do
      assert page.has_content? member_group_points
    end
  end
end
