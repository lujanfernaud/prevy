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

class Notification < ApplicationRecord
  belongs_to :user

  validates :message, presence: true

  def link
    {}
  end

  def redirecter_path(**params)
    NotificationRedirecter.path(self, **params)
  end
end
