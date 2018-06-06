require 'test_helper'

class NewAnnouncementTopicJobTest < ActiveJob::TestCase
  def setup
    @user  = users(:phil)
    @topic = announcement_topics(:announcement_topic_one)
  end

  test "queues job" do
    assert_enqueued_jobs 1 do
      NewAnnouncementTopicJob.perform_later(@user, @topic)
    end
  end

  test "job delivers email" do
    assert_difference("ActionMailer::Base.deliveries.size", +1) do
      NewAnnouncementTopicJob.perform_now(@user, @topic)
    end
  end
end
