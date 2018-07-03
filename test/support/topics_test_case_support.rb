# frozen_string_literal: true

module TopicsTestCaseSupport
  def fake_announcement_topic(group)
    group.announcement_topics.new(
      user:  fake_user,
      title: "Test topic",
      body:  "Body of test topic. " * 3
    )
  end
end
