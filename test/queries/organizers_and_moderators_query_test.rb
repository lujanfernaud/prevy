# frozen_string_literal: true

require 'test_helper'

class OrganizersAndModeratorsQueryTest < ActiveSupport::TestCase
  test "returns group organizers and moderators" do
    stub_sample_content_for_new_users

    group      = create :group
    organizers = create_list :user, 3
    moderators = create_list :user, 3

    organizers.each { |user| user.add_role :organizer, group }
    moderators.each { |user| user.add_role :moderator, group }

    expectation = [group.owner, organizers, moderators].flatten
    result      = OrganizersAndModeratorsQuery.call(group)

    assert_equal expectation.pluck(:name), result.pluck(:name)
  end
end
