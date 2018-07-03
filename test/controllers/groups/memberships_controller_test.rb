# frozen_string_literal: true

require 'test_helper'

class Groups::MembershipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    ActionMailer::Base.deliveries.clear
  end

  test "should create group_membership" do
    group = groups(:one)
    owner = group.owner
    user  = users(:stranger)

    sign_in(owner)

    assert_difference('GroupMembership.count') do
      post group_memberships_url(
        group_id: group.id,
        user_id: user.id
      ), params: group_membership_params
    end

    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_redirected_to user_membership_requests_url(owner)
  end

  test "should destroy group_membership" do
    group = groups(:one)
    owner = group.owner
    user  = users(:woodell)

    sign_in(owner)

    assert_difference('GroupMembership.count', -1) do
      delete group_membership_url(group, user.id),
        headers: { "HTTP_REFERER": "back" }
    end

    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_redirected_to "back"
  end

  private

    def group_membership_params
      { group_membership:
        {
          user: users(:stranger),
          group: groups(:one)
        }
      }
    end
end
