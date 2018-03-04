require 'test_helper'

class MembershipRequestTest < ActiveSupport::TestCase
  test "user is already a member of the group" do
    membership_request = MembershipRequest.last
    duplicate_membership_request = membership_request.dup

    refute duplicate_membership_request.valid?
    assert_not_nil duplicate_membership_request.errors[:user]
  end
end
