# frozen_string_literal: true

require 'test_helper'

class GroupUserPolicyTest < ActiveSupport::TestCase
  def setup
    stub_sample_content_for_new_users

    @owner = create :user, :confirmed
    @group = create :group, owner: @owner
  end

  test "#user_is_authorized? is true for member" do
    user = create :user, :confirmed

    @group.members << user

    assert GroupUserPolicy.call(@group, user)
  end

  test "#user_is_authorized? is true for owner" do
    assert GroupUserPolicy.call(@group, @owner)
  end

  test "#user_is_authorized? is true for unconfirmed sample group owner" do
    user  = create :user
    group = create :group, owner: user, sample_group: true

    assert GroupUserPolicy.call(group, user)
  end

  test "#user_is_authorized? is false for unconfirmed member" do
    user = create :user

    @group.members << user

    assert_not GroupUserPolicy.call(@group, user)
  end

  test "#user_is_authorized? is false for everyone else" do
    stranger = users(:stranger)

    assert_not GroupUserPolicy.call(@group, stranger)
  end
end
