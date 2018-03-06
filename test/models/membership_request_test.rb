require 'test_helper'

class MembershipRequestTest < ActiveSupport::TestCase
  def setup
    @membership_request = membership_requests(:one)
  end

  test "not valid if user is already a member of the group" do
    duplicate_membership_request = @membership_request.dup

    refute duplicate_membership_request.valid?
    assert_not_nil duplicate_membership_request.errors[:user]
  end

  test "membership request notification is destroyed" do
    notification = @membership_request.notification

    @membership_request.destroy

    assert notification.destroyed?
  end
end
