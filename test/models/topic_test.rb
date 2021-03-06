# frozen_string_literal: true

# == Schema Information
#
# Table name: topics
#
#  id                :bigint(8)        not null, primary key
#  announcement      :boolean          default(FALSE)
#  body              :text
#  comments_count    :integer          default(0), not null
#  edited_at         :datetime         not null
#  last_commented_at :datetime
#  priority          :integer          default(0)
#  slug              :string
#  title             :string
#  type              :string           default("Topic")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  edited_by_id      :bigint(8)
#  event_id          :bigint(8)
#  group_id          :bigint(8)
#  user_id           :bigint(8)
#
# Indexes
#
#  index_topics_on_edited_by_id       (edited_by_id)
#  index_topics_on_event_id           (event_id)
#  index_topics_on_group_id           (group_id)
#  index_topics_on_id_and_type        (id,type)
#  index_topics_on_last_commented_at  (last_commented_at)
#  index_topics_on_priority           (priority)
#  index_topics_on_slug               (slug)
#  index_topics_on_user_id            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (user_id => users.id)
#

require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  include UserSupport

  def setup
    stub_sample_content_for_new_users
  end

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

    topic.save!

    assert_equal title_parameterized, topic.slug
  end

  test "#type_presentable" do
    topic = build :topic, type: "EventTopic"

    assert "Event", topic.type_presentable
  end

  test "#prioritized sorts by priority and last_commented_at" do
    prepare_group_topics

    older_announcement_topic.update_attributes(last_commented_at: Time.current)
    older_event_topic.update_attributes(last_commented_at: Time.current)
    older_pinned_topic.update_attributes(last_commented_at: Time.current)
    older_normal_topic.update_attributes(last_commented_at: Time.current)

    expected_result = [
      older_announcement_topic, newer_announcement_topic,
      older_event_topic, newer_event_topic,
      older_pinned_topic, newer_pinned_topic,
      older_normal_topic, newer_normal_topic
    ]

    assert_equal expected_result.map(&:id), group.topics_prioritized.map(&:id)
  end

  test "sets author as default edited_by on save" do
    topic = fake_topic
    topic.save!

    assert_equal topic.user, topic.edited_by
  end

  test "#edited? is true when outside of EDITED_OFFSET_TIME" do
    topic = fake_topic
    topic.save!

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
    topic.save!

    topic.update_attributes(
      created_at: 10.minutes.ago,
      updated_at: 5.minutes.ago,
      edited_by:  penny
    )

    assert topic.edited?
  end

  test "edited_at changes when the topic title is updated" do
    topic = fake_topic
    topic.save!

    previous_edited_at = topic.edited_at

    topic.update_attributes(title: "Updated title")

    refute_equal previous_edited_at, topic.edited_at
  end

  test "edited_at changes when the topic body is updated" do
    topic = fake_topic
    topic.save!

    previous_edited_at = topic.edited_at

    topic.update_attributes(body: "This is the updated body of the topic.")

    refute_equal previous_edited_at, topic.edited_at
  end

  test "edited_at remains unchanged when the topic is touched" do
    topic = fake_topic
    topic.save!

    previous_edited_at = topic.edited_at

    topic.touch

    assert_equal previous_edited_at, topic.edited_at
    refute_equal topic.edited_at, topic.updated_at
  end

  test "touches group when adding a topic" do
    topic = topics(:one)
    group = groups(:one)
    group.update_attributes(name: "Test group")
    group.update_attributes(updated_at: 1.day.ago)

    assert_in_delta 1.day.ago, group.updated_at, 5.minutes

    group.topics.create!(
      user:  SampleUser.all.sample,
      title: "Test topic",
      body:  "This is the body of the test topic."
    )

    assert_in_delta topic.reload.updated_at, group.reload.updated_at, 5.minutes
  end

  test "touches user when creating a topic" do
    user  = create :user
    group = create :group
    group.members << user

    user.update_attributes(updated_at: 1.day.ago)

    assert_in_delta 1.day.ago, user.updated_at, 5.minutes

    group.topics.create!(
      user:  user,
      title: "Test topic",
      body:  "This is the body of the test topic."
    )

    topic = Topic.last

    assert_in_delta topic.reload.updated_at, user.reload.updated_at, 5.minutes
  end

  test "sets default last_commented_at after create" do
    topic = group.topics.create!(
      user:  SampleUser.all.sample,
      title: "Test topic",
      body:  "This is the body of the test topic."
    )

    assert topic.last_commented_at
  end

  test "increases count for UserGroupPoints" do
    topic = build :topic

    points_amount = UserGroupPoints.new
    UserGroupPoints.expects(:find_or_create_by!).returns(points_amount)
    points_amount.expects(:increase).with(by: Topic::POINTS)

    topic.save!
  end

  test "decreases count for UserGroupPoints" do
    topic = create :topic

    group_points = UserGroupPoints.new
    UserGroupPoints.expects(:find_or_create_by!).returns(group_points)
    group_points.expects(:decrease).with(by: Topic::POINTS)

    topic.destroy!
  end

  private

    def prepare_group_topics
      group.event_topics.offset(2).destroy_all
      group.normal_topics.offset(2).destroy_all
    end

    def group
      @_group ||= groups(:one)
    end

    def newer_announcement_topic
      group.announcement_topics.order(:last_commented_at).first
    end

    def older_announcement_topic
      group.announcement_topics.order(:last_commented_at).last
    end

    def newer_event_topic
      group.event_topics.order(:last_commented_at).first
    end

    def older_event_topic
      group.event_topics.order(:last_commented_at).last
    end

    def newer_pinned_topic
      group.pinned_topics.order(:last_commented_at).first
    end

    def older_pinned_topic
      group.pinned_topics.order(:last_commented_at).last
    end

    def newer_normal_topic
      group.normal_topics.last
    end

    def older_normal_topic
      group.normal_topics.first
    end
end
