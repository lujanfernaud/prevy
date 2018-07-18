# frozen_string_literal: true

require 'test_helper'

class UserSampleContentCreatorTest < ActiveSupport::TestCase
  test "creates sample content if user is a regular user" do
    user = create :user, skip_sample_content: true
    user.update_attributes(skip_sample_content: false)

    group = create :group, owner: user, sample_group: true

    SampleGroupCreator.expects(:call).with(user).returns(group)
    SampleEventCreator.expects(:call).with(group)
    SampleTopicCreator.expects(:call).with(group)
    SampleInvitationCreator.expects(:call).with(group, quantity: 3)
    SampleMembershipRequestCreator.expects(:call).with(user)

    UserSampleContentCreator.call(user)
  end
end
