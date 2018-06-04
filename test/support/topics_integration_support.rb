module TopicsIntegrationSupport
  def assert_topics(group)
    assert page.has_content? "Topics"
    assert page.has_css?     ".topics-box"
  end

  def refute_topics
    refute page.has_css? ".topics-container"
  end

  def submit_new_topic_with(title, body, announcement: false)
    click_on "Submit a new topic"

    fill_topic_fields_with title, body

    set_announcement_to(announcement)

    click_on "Create topic"
  end

  def set_announcement_to(value)
    within ".announcement-box" do
      choose "topic_announcement_#{value}"
    end
  end

  def submit_new_announcement_topic
    submit_new_topic_with(
      "Test topic",
      "This is the body of the test topic.",
      announcement: true
    )
  end

  def update_topic_with(title, body)
    click_on "Edit"

    fill_topic_fields_with title, body

    click_on "Update topic"
  end

  def fill_topic_fields_with(title, body)
    fill_in "Title", with: title
    fill_in_body_with body
  end

  def fill_in_body_with(text)
    find("trix-editor").click.set(text)
  end

  def assert_last_topic_has_label(label, group:)
    within last_topic_id(group) do
      assert page.has_content? label
    end
  end

  def last_topic_id(group)
    "#topic-#{group.topics.last.id}"
  end

  def refute_topic_has_label(label, topic:)
    within "#topic-#{topic.id}" do
      refute page.has_content? label
    end
  end

  # TODO: Extract the following methods to comments_integration_support.rb
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
