# frozen_string_literal: true

require 'test_helper'

class Groups::TopicsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group = groups(:one)
    @phil  = users(:phil)
    @penny = users(:penny)
    @topic = topics(:one)
  end

  test "should get index" do
    sign_in @penny
    @group.members << @penny

    get group_topics_url(@group)

    assert_response :success
  end

  test "should get new" do
    sign_in @phil

    get new_group_topic_url(@group)

    assert_response :success
  end

  test "should create topic" do
    sign_in @phil

    assert_difference('Topic.count') do
      post group_topics_url(@group), params: topic_params
    end

    assert_redirected_to group_topic_url(@group, Topic.last)
  end

  test "should create announcement topic" do
    NewAnnouncementNotification.expects(:call)

    sign_in @phil

    assert_difference('AnnouncementTopic.count') do
      post group_topics_url(@group),
        params: topic_params(type: "AnnouncementTopic")
    end

    assert_redirected_to group_topic_url(@group, AnnouncementTopic.last)
  end

  test "should create pinned topic" do
    sign_in @phil

    assert_difference('PinnedTopic.count') do
      post group_topics_url(@group), params: topic_params(type: "PinnedTopic")
    end

    assert_redirected_to group_topic_url(@group, PinnedTopic.last)
  end

  test "should show topic" do
    sign_in @penny
    @group.members << @penny

    get group_topic_url(@group, @topic)

    assert_response :success
  end

  test "should get edit" do
    sign_in @phil

    get edit_group_topic_url(@group, @topic)

    assert_response :success
  end

  test "should update topic" do
    sign_in @phil

    new_params = topic_params.merge({ topic: { title: "New title" } })

    patch group_topic_url(@group, @topic), params: new_params

    topic = Topic.find(@topic.id)

    assert_redirected_to group_topic_url(@group, topic)
  end

  test "should destroy group_topic" do
    sign_in @phil

    assert_difference('Topic.count', -1) do
      delete group_topic_url(@group, @topic)
    end

    assert_redirected_to group_topics_url(@group)
  end

  private

    def topic_params(type: "Topic")
      {
        topic: {
          title: @topic.title,
          body: @topic.body,
          type: type
        }
      }
    end
end
