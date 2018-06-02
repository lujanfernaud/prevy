# frozen_string_literal: true

# Used when redirecting back using an anchor link (ex: #comment-23),
# to show the previous comment if it exists, or the main container.
#
# We want to show some context to the comment that we just posted.
class PreviousCommentCSSIdLocator

  def self.call(comment)
    new(comment).locate
  end

  def initialize(comment)
    @comment = comment
  end

  def locate
    if comment_is_the_first_comment
      container_css_id
    else
      previous_comment_css_id
    end
  end

  private

    attr_reader :comment

    def comment_is_the_first_comment
      comment == topic_comments.first
    end

    def topic_comments
      comment.topic.comments
    end

    def container_css_id
      "#comments"
    end

    def previous_comment_css_id
      "#comment-#{previous_comment.id}"
    end

    def previous_comment
      comment_index = topic_comments.find_index(comment)

      topic_comments[comment_index - 1]
    end

end
