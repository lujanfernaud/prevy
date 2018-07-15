# frozen_string_literal: true

require 'test_helper'

class PrioritizedTopicsQueryTest < ActiveSupport::TestCase
  def setup
    @group = groups(:two)
  end

  test "#topics_prioritized removes priority to past events topics" do
    @group.topics_prioritized

    past_events_topics = @group.events.past.map(&:topic)

    assert topics_have_zero_priority? past_events_topics
  end

  test "#topics_prioritized doesn't remove priority to upcoming events" do
    @group.topics_prioritized

    upcoming_events_topics = @group.events.upcoming.map(&:topic)

    assert_not topics_have_zero_priority? upcoming_events_topics
  end

  private

    def topics_have_zero_priority?(topics)
      topics.map(&:priority).all?(&:zero?)
    end
end
