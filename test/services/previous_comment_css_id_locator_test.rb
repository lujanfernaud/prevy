# frozen_string_literal: true

require 'test_helper'

class PreviousCommentCSSIdLocatorTest < ActiveSupport::TestCase
  attr_reader :topic

  def setup
    @topic = topics(:one)
  end

  test "locates previous comment CSS id if there is a previous comment" do
    comment = topic.comments[-1]
    previous_comment = find_previous_comment_for topic, comment

    result = PreviousCommentCSSIdLocator.call(comment, @topic)

    assert_equal "#comment-#{previous_comment.id}", result
  end

  test "locates previous comment CSS id with previous being deleted" do
    comment = topic.comments[-1]
    previous_comment_one = topic.comments[-2]
    previous_comment_two = topic.comments[-3]

    previous_comment_one.destroy

    result = PreviousCommentCSSIdLocator.call(comment, @topic)

    assert_equal "#comment-#{previous_comment_two.id}", result
  end

  test "locates container CSS id if there is not a previous comment" do
    comment = topic.comments.first

    result = PreviousCommentCSSIdLocator.call(comment, @topic)

    assert_equal "#comments", result
  end

  private

    def find_previous_comment_for(topic, comment)
      comment_index = topic.comments.find_index(comment)

      topic.comments[comment_index - 1]
    end
end
