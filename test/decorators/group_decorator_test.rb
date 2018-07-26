# frozen_string_literal: true

require 'test_helper'

class GroupDecoratorTest < ActiveSupport::TestCase
  def setup
    stub_sample_content_for_new_users
  end

  test "#admin_name_or_link returns link to owner when the user is invited" do
    user  = nil
    group = GroupDecorator.new(create :group)
    invitation = create :group_invitation, group: group

    InvitationAuthorizer.stubs(:call).returns(true)

    result = group.admin_name_or_link(user, invitation.token)

    assert result.include? "href"
  end

  test "#admin_name_or_link returns owner name when the user is not invited" do
    user  = create :user
    group = GroupDecorator.new(create :group)
    invitation = create :group_invitation, group: group

    InvitationAuthorizer.stubs(:call).returns(false)

    result = group.admin_name_or_link(user, invitation.token)

    assert result.include? group.owner.name
  end

  test "#membership_button returns requested membership button" do
    user  = create :user
    token = nil
    group = GroupDecorator.new(create :group)
    create :membership_request, user: user, group: group

    result = group.membership_button(user, token)

    assert result.include? "Membership requested"
  end

  test "#membership_button returns join button" do
    user  = create :user
    token = 123456789
    group = GroupDecorator.new(create :group)

    InvitationAuthorizer.stubs(:call).returns(true)

    result = group.membership_button(user, token)

    assert result.include? "Yes!"
  end

  test "#membership_button returns request membership button" do
    user  = create :user
    token = nil
    group = GroupDecorator.new(create :group)

    InvitationAuthorizer.stubs(:call).returns(false)

    result = group.membership_button(user, token)

    assert result.include? "Request membership"
  end

  test "#see_all_members_link doesn't return link" do
    group = GroupDecorator.new(create :group)

    group.stubs(:members_count).returns(Group::RECENT_MEMBERS - 1)

    result = group.see_all_members_link

    assert_nil result
  end

  test "#see_all_members_link returns link" do
    group = GroupDecorator.new(create :group)

    group.stubs(:members_count).returns(Group::RECENT_MEMBERS + 1)

    result = group.see_all_members_link

    assert result.include? "See all members"
  end

  test "#create_event_button_authorized? is true for sample groups" do
    user  = create :user
    group = GroupDecorator.new(create :group, sample_group: true)

    user.stubs(:has_role?).with(:organizer, group).returns(true)

    assert group.create_event_button_authorized?(user)
  end

  test "#create_event_button_authorized? is true for confirmed organizer" do
    user  = create :user, :confirmed
    group = GroupDecorator.new(create :group)

    user.stubs(:has_role?).with(:organizer, group).returns(true)

    assert group.create_event_button_authorized?(user)
  end

  test "#create_event_button_authorized? is false for unconfirmed organizer" do
    user  = create :user
    group = GroupDecorator.new(create :group)

    user.stubs(:has_role?).with(:organizer, group).returns(true)

    assert_not group.create_event_button_authorized?(user)
  end

  test "#members_title_with_count" do
    group = GroupDecorator.new(create :group)
    group.stubs(:members_count).returns(1)

    assert "Members (0)", group.members_title_with_count

    group.stubs(:members_count).returns(9)

    assert "Members (9)", group.members_title_with_count
  end

  test "#organizers_title" do
    group = GroupDecorator.new(create :group)
    group.stubs(:organizers).returns([1])

    assert "Organizer", group.organizers_title

    group.stubs(:organizers).returns([1, 2])

    assert "Organizers (2)", group.organizers_title
  end

  test "#top_members_selection shows maximum amount" do
    top_members = Group::TOP_MEMBERS
    group_one = GroupDecorator.new(create :group)

    more_than_top_members = create_list :user, top_members + 1, :confirmed
    group_one.members << more_than_top_members

    assert_equal top_members, group_one.top_members_selection.size
  end

  test "#top_members_selection shows half amount" do
    top_members = Group::TOP_MEMBERS
    group_two = GroupDecorator.new(create :group)

    less_than_top_members = create_list :user, top_members - 1, :confirmed
    group_two.members << less_than_top_members

    assert_equal (top_members / 2), group_two.top_members_selection.size
  end

  test "#user_points" do
    group = GroupDecorator.new(create :group)
    user  = create :user

    user.stubs(:group_points_amount).returns(9)

    assert_equal "(9 points)", group.user_points(user)
  end
end
