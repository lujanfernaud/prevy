require 'test_helper'

class TopicTest < ActiveSupport::TestCase
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

    refute topic.valid?, "body is not present"
  end

  test "is invalid with too short title" do
    topic = fake_topic(title: "H")

    refute topic.valid?, "title is too short"
  end

  test "is invalid with too short body" do
    topic = fake_topic(body: "Hello :)")

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

  private

    def fake_topic(params = {})
      Topic.new(
        group: params[:group] || groups(:one),
        user:  params[:user]  || users(:phil),
        title: params[:title] || "Welcome!",
        body:  params[:body]  || "Welcome to the group :)"
      )
    end
end
