require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  include UserSupport

  test "is valid" do
    topic = fake_topic

    assert topic.valid?
  end

  test "is invalid without title" do
    topic = fake_topic(title: "")

    refute topic.valid?, "title is not present"
  end

  test "is invalid without body" do
    topic = fake_topic(body: "")

    refute topic.valid?, "body is too short"
  end

  test "is invalid with too short title" do
    topic = fake_topic(title: "H")

    refute topic.valid?, "title is too short"
  end

  test "is invalid with too short body" do
    topic = fake_topic(body: "Hello :)")

    refute topic.valid?, "body is too short"
  end

  test "is invalid with too short body with unparsed HTML" do
    spaces = "#{"&nbsp;" * 30}"

    topic = fake_topic(body: "<div>#{spaces}</div>")

    refute topic.valid?, "body is too short"
  end

  test "belongs to group" do
    topic = fake_topic

    assert topic.group
  end

  test "belongs to user" do
    topic = fake_topic

    assert topic.user
  end

  test "#comments" do
    topic = fake_topic

    assert_equal [], topic.comments
  end

  test "has title as slug" do
    topic = fake_topic
    title_parameterized = topic.title.parameterize

    topic.save

    assert_equal title_parameterized, topic.slug
  end

  test "#type_presentable" do
    topic = fake_event_topic(type: "EventTopic")

    assert "Event", topic.type_presentable
  end

  test "#prioritized sorts by priority and date" do
    prepare_group_topics

    older_event_topic.touch
    older_normal_topic.touch

    expected_result = [
      older_event_topic, newer_event_topic,
      older_normal_topic, newer_normal_topic
    ]

    assert_equal expected_result, group.topics.prioritized
  end

  private

    def fake_event_topic(params = {})
      fake_topic(
        event: params[:event] || fake_event,
        group: fake_group,
        user:  fake_user,
        type:  params[:type] || "EventTopic"
      )
    end

    def prepare_group_topics
      group_event_topics.offset(2).destroy_all
      group_normal_topics.offset(2).destroy_all
    end

    def group_event_topics
      group.topics.events
    end

    def group_normal_topics
      group.topics.normal
    end

    def group
      @_group ||= groups(:one)
    end

    def newer_event_topic
      group_event_topics.first
    end

    def older_event_topic
      group_event_topics.last
    end

    def newer_normal_topic
      group_normal_topics.first
    end

    def older_normal_topic
      group_normal_topics.last
    end
end
