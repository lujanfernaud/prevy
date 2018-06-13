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

    older_announcement_topic.touch
    older_event_topic.touch
    older_normal_topic.touch

    expected_result = [
      older_announcement_topic, newer_announcement_topic,
      older_event_topic, newer_event_topic,
      older_normal_topic, newer_normal_topic
    ]

    assert_equal expected_result, group.topics.prioritized
  end

  test "sets author as default edited_by on save" do
    topic = fake_topic
    topic.save

    assert_equal topic.user, topic.edited_by
  end

  test "#edited? is true when outside of EDITED_OFFSET_TIME" do
    topic = fake_topic
    topic.save

    topic.update_attributes(
      created_at: 10.minutes.ago,
      updated_at: 5.minutes.ago
    )

    refute topic.edited?

    topic.update_attributes(
      created_at: 20.minutes.ago,
      updated_at: 9.minutes.ago
    )

    assert topic.edited?
  end

  test "#edited? is true always if not edited by author" do
    phil  = users(:phil)
    penny = users(:penny)
    topic = fake_topic(user: phil)
    topic.save

    topic.update_attributes(
      created_at: 10.minutes.ago,
      updated_at: 5.minutes.ago,
      edited_by:  penny
    )

    assert topic.edited?
  end

  test "edited_at changes when the topic title is updated" do
    topic = fake_topic
    topic.save

    previous_edited_at = topic.edited_at

    topic.update_attributes(title: "Updated title")

    refute_equal previous_edited_at, topic.edited_at
  end

  test "edited_at changes when the topic body is updated" do
    topic = fake_topic
    topic.save

    previous_edited_at = topic.edited_at

    topic.update_attributes(body: "This is the updated body of the topic.")

    refute_equal previous_edited_at, topic.edited_at
  end

  test "edited_at is set if it was empty" do
    topic = fake_topic
    topic.save

    assert topic.edited_at
  end

  test "edited_at remains unchanged when the topic is touched" do
    topic = fake_topic
    topic.save

    previous_edited_at = topic.edited_at

    topic.touch

    assert_equal previous_edited_at, topic.edited_at
    refute_equal topic.edited_at, topic.updated_at
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

    def prepare_group_topics
      group.event_topics.offset(2).destroy_all
      group.normal_topics.offset(2).destroy_all
    end

    def group
      @_group ||= groups(:one)
    end

    def newer_announcement_topic
      group.announcement_topics.first
    end

    def older_announcement_topic
      group.announcement_topics.last
    end

    def newer_event_topic
      group.event_topics.first
    end

    def older_event_topic
      group.event_topics.last
    end

    def newer_normal_topic
      group.normal_topics.first
    end

    def older_normal_topic
      group.normal_topics.last
    end
end
