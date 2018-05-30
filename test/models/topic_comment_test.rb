require 'test_helper'

class TopicCommentTest < ActiveSupport::TestCase
  test "is valid" do
    comment = fake_comment

    assert comment.valid?
  end

  test "is invalid without body" do
    comment = fake_comment(body: "")

    refute comment.valid?, "body is not present"
  end

  test "is invalid with too short body" do
    comment = fake_comment(body: "Hi")

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

  private

    def fake_comment(params = {})
      TopicComment.new(
        topic: params[:topic] || topics(:one),
        user:  params[:user]  || users(:penny),
        body:  params[:body]  || "Hey! Welcome :)"
      )
    end
end
