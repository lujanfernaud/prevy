# frozen_string_literal: true
# == Schema Information
#
# Table name: membership_requests
#
#  id         :bigint(8)        not null, primary key
#  message    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :bigint(8)
#  user_id    :bigint(8)
#
# Indexes
#
#  index_membership_requests_on_group_id  (group_id)
#  index_membership_requests_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (user_id => users.id)
#

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

  test ".find_sent" do
    user = users(:phil)
    sent = [membership_requests(:three)]

    assert_equal sent, MembershipRequest.find_sent(user)
  end

  test ".find_received" do
    user = users(:phil)
    received = [membership_requests(:one), membership_requests(:two)]

    assert_equal received, MembershipRequest.find_received(user)
  end
end
