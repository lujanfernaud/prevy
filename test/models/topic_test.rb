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

  private

    def fake_event_topic(params = {})
      fake_topic(
        event: fake_event,
        group: fake_group,
        user:  fake_user,
        type:  params[:type] || "EventTopic"
      )
    end
end
