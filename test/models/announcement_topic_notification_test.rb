# == Schema Information
#
# Table name: notifications
#
#  id                    :bigint(8)        not null, primary key
#  user_id               :bigint(8)
#  membership_request_id :bigint(8)
#  group_membership_id   :bigint(8)
#  type                  :string
#  message               :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  group_id              :bigint(8)
#  topic_id              :bigint(8)
#

require 'test_helper'

class AnnouncementTopicNotificationTest < ActiveSupport::TestCase
  include UserSupport
  include TopicsTestCaseSupport

  def setup
    @notification =
      announcement_topic_notifications(:announcement_topic_notification_one)
  end

  test "#link" do
    text   = "Go to announcement"
    path   = path_with_params
    result = @notification.link

    assert_equal({ text: text, path: path }, result)
  end

  private

    def path_with_params
      Rails.application.routes.url_helpers
           .user_notification_redirecter_path(
             @notification.user,
             notification: @notification,
             group: @notification.group,
             topic: @notification.topic
           )
    end
end
