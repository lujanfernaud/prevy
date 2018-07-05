# frozen_string_literal: true

require 'test_helper'

class GroupInvitationEmailJobTest < ActiveJob::TestCase
  def setup
    @invitation = build_stubbed :group_invitation
  end

  test "queues job" do
    assert_enqueued_jobs 1 do
      GroupInvitationEmailJob.perform_later(@invitation)
    end
  end

  test "job delivers email" do
    assert_difference("ActionMailer::Base.deliveries.size", +1) do
      GroupInvitationEmailJob.perform_now(@invitation)
    end
  end
end
