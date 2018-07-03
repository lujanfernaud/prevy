# frozen_string_literal: true
# == Schema Information
#
# Table name: topic_comments
#
#  id           :bigint(8)        not null, primary key
#  body         :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  edited_by_id :bigint(8)
#  topic_id     :bigint(8)
#  user_id      :bigint(8)
#
# Indexes
#
#  index_topic_comments_on_topic_id  (topic_id)
#  index_topic_comments_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (topic_id => topics.id)
#  fk_rails_...  (user_id => users.id)
#

require 'test_helper'

class TopicCommentTest < ActiveSupport::TestCase
  test "is valid" do
    comment = fake_comment

    assert comment.valid?
  end

  test "is invalid without body" do
    comment = fake_comment(body: "")

    refute comment.valid?, "body is too short"
  end

  test "is invalid with blank body" do
    comment = fake_comment(body: " ")

    refute comment.valid?, "body is too short"
  end

  test "is invalid with too short body" do
    comment = fake_comment(body: "H")

    refute comment.valid?, "body is too short"
  end

  test "is invalid with too short body with unparsed HTML" do
    comment = fake_comment(body: "<div>&nbsp; &nbsp; &nbsp;</div>")

    refute comment.valid?, "body is too short"
  end

  test "belongs to topic" do
    comment = fake_comment

    assert comment.topic
  end

  test "belongs to user" do
    comment = fake_comment

    assert comment.user
  end

  test "sets author as default edited_by on save" do
    comment = fake_comment
    comment.save

    assert_equal comment.user, comment.edited_by
  end

  test "#edited? is true when outside of EDITED_OFFSET_TIME" do
    comment = fake_comment
    comment.save

    comment.update_attributes(
      created_at: 5.minutes.ago,
      updated_at: 3.minutes.ago
    )

    refute comment.edited?

    comment.update_attributes(
      created_at: 10.minutes.ago,
      updated_at: 3.minutes.ago
    )

    assert comment.edited?
  end

  test "#edited? is true always if not edited by author" do
    phil    = users(:phil)
    penny   = users(:penny)
    comment = fake_comment(user: phil)
    comment.save

    comment.update_attributes(
      created_at: 5.minutes.ago,
      updated_at: 3.minutes.ago,
      edited_by:  penny
    )

    assert comment.edited?
  end

  test "updates topic's last_commented_at after create" do
    phil  = users(:phil)
    topic = fake_topic
    topic.save

    topic.update_column(:last_commented_at, nil)

    comment = fake_comment(user: phil, topic: topic)
    comment.save

    assert_equal comment.created_at, topic.last_commented_at
  end

  test "increases count for UserGroupPoints" do
    stranger = users(:stranger)
    comment  = fake_comment(user: stranger)

    points_amount = UserGroupPoints.new
    UserGroupPoints.expects(:find_or_create_by!).returns(points_amount)
    points_amount.expects(:increase)

    comment.save!
  end

  test "decreases count for UserGroupPoints" do
    stranger = users(:stranger)
    comment  = fake_comment(user: stranger)

    group_points = UserGroupPoints.new
    UserGroupPoints.expects(:find_or_create_by!).returns(group_points)
    group_points.expects(:decrease)

    comment.destroy!
  end

  test "group can be destroyed without a foreign key constraint error" do
    group = groups(:one)

    assert group.destroy!
  end
end
