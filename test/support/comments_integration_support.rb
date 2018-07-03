# frozen_string_literal: true

module CommentsIntegrationSupport
  def submit_new_comment_with(body)
    fill_in_body_with body

    click_on "Submit a new comment"
  end

  def click_on_edit_comment(comment)
    within "#comment-#{comment.id}" do
      click_on "Edit"
    end
  end

  def update_comment_with(body)
    fill_in_body_with body

    click_on "Update comment"
  end
end
