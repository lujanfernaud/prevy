require 'test_helper'

class BodyLengthValidatorTest < ActiveSupport::TestCase
  test "adds error when topic body is too short" do
    spaces = "#{"&nbsp;" * 30}"
    topic  = fake_topic(body: "<div>#{spaces}</div>")
    topic.save

    assert topic.errors.include? :body
  end

  test "doesn't add error when topic body is long enough" do
    message = "This is the sample body of the topic."
    topic   = fake_topic(body: "<div>#{message}</div>")
    topic.save

    refute topic.errors.include? :body
  end

  test "adds error when comment body is too short" do
    spaces  = "#{"&nbsp;" * 30}"
    comment = fake_comment(body: "<div>#{spaces}</div>")
    comment.save

    assert comment.errors.include? :body
  end

  test "doesn't add error when comment body is long enough" do
    message = "This is the sample body of the comment."
    comment = fake_comment(body: "<div>#{message}</div>")
    comment.save

    refute comment.errors.include? :body
  end
end
