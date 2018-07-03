# frozen_string_literal: true

require 'test_helper'

class NewEventJobTest < ActiveJob::TestCase
  def setup
    @user  = users(:phil)
    @group = groups(:one)
    @event = events(:one)
  end

  test "queues job" do
    assert_enqueued_jobs 1 do
      NewEventJob.perform_later(@user, @group, @event)
    end
  end

  test "job delivers email" do
    assert_difference("ActionMailer::Base.deliveries.size", +1) do
      NewEventJob.perform_now(@user, @group, @event)
    end
  end
end
