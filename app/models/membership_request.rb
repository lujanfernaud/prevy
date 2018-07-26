# frozen_string_literal: true

# == Schema Information
#
# Table name: membership_requests
#
#  id         :bigint(8)        not null, primary key
#  message    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :bigint(8)
#  user_id    :bigint(8)
#
# Indexes
#
#  index_membership_requests_on_group_id  (group_id)
#  index_membership_requests_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (user_id => users.id)
#

class MembershipRequest < ApplicationRecord
  belongs_to :group
  belongs_to :user

  has_one :notification, dependent: :destroy

  validates_uniqueness_of :user, scope: :group,
    message: "is already a member of the group"

  before_save :set_default_message

  scope :find_sent, -> (user) {
    includes(:group).
    where(user: user).
    order(created_at: :desc)
  }

  scope :find_received, -> (user) {
    includes(:group, :user).
    where(group: user.owned_groups).
    order(created_at: :desc)
  }

  private

    def set_default_message
      self.message = "No message." if message.empty?
    end
end
