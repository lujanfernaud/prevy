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

class GroupInvitationNotificationTest < ActiveSupport::TestCase
  URL_HELPERS = Notification::URL_HELPERS

  def setup
    stub_sample_content_for_new_users
  end

  test "user has invitation notification" do
    user  = create :user
    group = create :group

    create :notification, :group_invitation, user: user, group_id: group.id

    assert_equal 1, user.notifications.size
  end

  test "group has invitation notification" do
    user  = create :user
    group = create :group

    create :notification, :group_invitation, user: user, group_id: group.id

    assert_equal 1, group.notifications.size
  end

  test "link path has invitation token" do
    user  = create :user
    group = create :group
    invitation = create :group_invitation, group: group, email: user.email
    create :notification, :group_invitation, user: user, group_id: group.id

    notification = user.notifications.last

    assert notification.link[:path].include?(invitation.token)
  end

  test "#resource_path" do
    user  = create :user
    group = create :group
    invitation = create :group_invitation, group: group, email: user.email
    create :notification, :group_invitation, user: user, group_id: group.id

    notification = user.notifications.last

    expected = URL_HELPERS.group_path(group, token: invitation.token)

    assert_equal expected, notification.resource_path
  end
end
