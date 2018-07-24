# frozen_string_literal: true

# == Schema Information
#
# Table name: notifications
#
#  id                    :bigint(8)        not null, primary key
#  message               :string
#  type                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  group_id              :bigint(8)
#  group_membership_id   :bigint(8)
#  membership_request_id :bigint(8)
#  topic_id              :bigint(8)
#  user_id               :bigint(8)
#
# Indexes
#
#  index_notifications_on_group_id               (group_id)
#  index_notifications_on_group_membership_id    (group_membership_id)
#  index_notifications_on_id_and_type            (id,type)
#  index_notifications_on_membership_request_id  (membership_request_id)
#  index_notifications_on_topic_id               (topic_id)
#  index_notifications_on_user_id                (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require 'test_helper'

class GroupMembershipNotificationTest < ActiveSupport::TestCase
  URL_HELPERS = Notification::URL_HELPERS

  include UserSupport
  include TopicsTestCaseSupport

  def setup
    @notification =
      group_membership_notifications(:membership_notifications_one)
  end

  test "#link" do
    text   = "Go to group"
    path   = path_with_params
    result = @notification.link

    assert_equal({ text: text, path: path }, result)
  end

  test "#resource_path" do
    expected = URL_HELPERS.group_path(@notification.group)

    assert_equal expected, @notification.resource_path
  end

  private

    def path_with_params
      URL_HELPERS.user_notification_redirecter_path(
        @notification.user,
        notification: @notification
      )
    end
end
