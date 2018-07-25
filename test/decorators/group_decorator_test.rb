# frozen_string_literal: true

require 'test_helper'

class GroupDecoratorTest < ActiveSupport::TestCase
  def setup
    stub_sample_content_for_new_users
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
