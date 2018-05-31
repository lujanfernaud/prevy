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
end
