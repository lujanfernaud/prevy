# frozen_string_literal: true

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

class GroupMembershipNotification < Notification
  belongs_to :group_membership

  def group
    group_membership.group
  end

  def link
    { text: "Go to group", path: notification_redirecter_path }
  end

  private

    def notification_redirecter_path
      redirecter_path(group: group)
    end
end
