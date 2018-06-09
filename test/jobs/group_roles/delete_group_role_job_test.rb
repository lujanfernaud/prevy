require 'test_helper'

class DeleteGroupRoleJobTest < ActiveJob::TestCase
  def setup
    @user  = users(:phil)
    @group = groups(:one)
    @role  = "organizer"
  end

  test "queues job" do
    assert_enqueued_jobs 1 do
      DeleteGroupRoleJob.perform_later(@user, @group, @role)
    end
  end

  test "job delivers email" do
    assert_difference("ActionMailer::Base.deliveries.size", +1) do
      DeleteGroupRoleJob.perform_now(@user, @group, @role)
    end
  end
end
