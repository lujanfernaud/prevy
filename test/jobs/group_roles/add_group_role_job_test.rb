# frozen_string_literal: true

require 'test_helper'

class AddGroupRoleJobTest < ActiveJob::TestCase
  def setup
    @user  = users(:phil)
    @group = groups(:one)
    @role  = "organizer"
  end

  test "queues job" do
    assert_enqueued_jobs 1 do
      AddGroupRoleJob.perform_later(@user, @group, @role)
    end
  end

  test "job delivers email" do
    assert_difference("ActionMailer::Base.deliveries.size", +1) do
      AddGroupRoleJob.perform_now(@user, @group, @role)
    end
  end
end
