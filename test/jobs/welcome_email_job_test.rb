# frozen_string_literal: true

require 'test_helper'

class WelcomeEmailJobTest < ActiveJob::TestCase
  def setup
    @user = build_stubbed :user
  end

  test "queues job" do
    assert_enqueued_jobs 1 do
      WelcomeEmailJob.perform_later(@user)
    end
  end

  test "job delivers email" do
    assert_difference("ActionMailer::Base.deliveries.size", +1) do
      WelcomeEmailJob.perform_now(@user)
    end
  end
end
