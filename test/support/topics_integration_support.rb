module TopicsIntegrationSupport
  def assert_topics(group)
    assert page.has_content? "Topics"
    assert page.has_css?     ".topics-box"
  end

  def refute_topics
    refute page.has_css? ".topics-container"
  end

  def submit_new_topic_with(title, body, type: "Topic")
    click_on "Submit a new topic"

    fill_topic_fields_with title, body

    set_topic_type_to(type)

    click_on "Create topic"
  end

  def set_topic_type_to(type)
    within ".topic-type-box" do
      choose "topic_type_#{type.downcase}"
    end
  end

  def submit_new_announcement_topic
    submit_new_topic_with(
      "Test topic",
      "This is the body of the test topic.",
      type: "AnnouncementTopic"
    )
  end

  def submit_new_pinned_topic
    submit_new_topic_with(
      "Test topic",
      "This is the body of the test topic.",
      type: "PinnedTopic"
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
end
