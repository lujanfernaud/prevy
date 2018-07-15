# frozen_string_literal: true

require 'test_helper'

class GroupUsersWithRoleQueryTest < ActiveSupport::TestCase
  test "finds users with organizer role" do
    stub_sample_content_for_new_users

    organizers = create_list :user, 3, :confirmed
    members    = create_list :user, 5, :confirmed
    group      = create :group
    group.members << [members, organizers]

    organizers.each do |user|
      group.add_to_organizers user
    end

    assert organizers, GroupUsersWithRoleQuery.call(group, :organizer)
  end

  test "finds users with moderator role" do
    stub_sample_content_for_new_users

    moderators = create_list :user, 3, :confirmed
    members    = create_list :user, 5, :confirmed
    group      = create :group
    group.members << [members, moderators]

    moderators.each do |user|
      group.add_to_moderators user
    end

    assert moderators, GroupUsersWithRoleQuery.call(group, :moderator)
  end

  test "finds users with member role" do
    stub_sample_content_for_new_users

    moderators = create_list :user, 3, :confirmed
    members    = create_list :user, 5, :confirmed
    group      = create :group
    group.members << [members, moderators]

    assert members, GroupUsersWithRoleQuery.call(group, :member)
  end
end
