require 'test_helper'

class TopicsDeletionTest < ActionDispatch::IntegrationTest
  include TopicsIntegrationSupport

  def setup
    @group = groups(:one)
    @phil  = users(:phil)

    prepare_javascript_driver
  end

  test "author deletes topic" do
    topic = fake_topic
    topic.save

    log_in_as @phil

    visit edit_group_topic_path(@group, topic)

    click_on "Delete"

    assert page.has_content? "Topic deleted."
  end

  private

    def fake_topic(params = {})
      Topic.new(
        group: @group,
        user:  @phil,
        title: params[:title] || "Fake topic",
        body:  params[:body]  || "Body of the fake topic."
      )
    end
end
