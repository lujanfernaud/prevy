# frozen_string_literal: true

require 'test_helper'

class UserSampleContentCreatorTest < ActiveSupport::TestCase
  test "creates sample content if user is a regular user" do
    user = create :user, skip_sample_content: true
    user.update_attributes(skip_sample_content: false)

    create :group, owner: user, sample_group: true

    SampleGroupCreator.expects(:call).with(user)
    SampleEventCreator.expects(:call).with(user.sample_group)
    SampleTopicCreator.expects(:call).with(user.sample_group)
    SampleInvitationCreator.expects(:call).with(user.sample_group, quantity: 3)
    SampleMembershipRequestCreator.expects(:call).with(user)

    UserSampleContentCreator.call(user)
  end
end
