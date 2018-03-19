require 'test_helper'

class GroupMembershipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    ActionMailer::Base.deliveries.clear
  end

  test "should get index" do
    group = groups(:one)

    get group_members_url(group)

    assert_response :success
  end

  test "should create group_membership" do
    group = groups(:one)
    owner = group.owner
    user  = users(:stranger)
    membership_request = MembershipRequest.new(group: group, user: user)

    log_in_as(owner)

    assert_difference('GroupMembership.count') do
      post group_members_url(
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
    user  = users(:penny)

    log_in_as(owner)

    assert_difference('GroupMembership.count', -1) do
      delete group_member_url(group, user.id),
        headers: { "HTTP_REFERER": "back" }
    end

    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_redirected_to "back"
  end

  private

    def log_in_as(user)
      post login_url,
        params: { session: { email: user.email, password: "password" } }
    end

    def group_membership_params
      { group_membership:
        {
          user: users(:stranger),
          group: groups(:one)
        }
      }
    end
end
