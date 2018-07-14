# frozen_string_literal: true

require 'test_helper'

class SampleMembershipRequestCreatorTest < ActiveSupport::TestCase
  test "creates membership request and notification" do
    user = create :user, skip_sample_content: true
    user.update_attributes(skip_sample_content: false)

    create :group, owner: user, sample_group: true

    SampleMembershipRequestCreator.call(user)

    assert_equal 1, user.received_requests.size
    assert_equal 1, user.notifications.size
  end
end
