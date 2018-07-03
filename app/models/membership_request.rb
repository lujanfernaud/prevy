# == Schema Information
#
# Table name: membership_requests
#
#  id         :bigint(8)        not null, primary key
#  message    :string
#  group_id   :bigint(8)
#  user_id    :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class MembershipRequest < ApplicationRecord
  belongs_to :group
  belongs_to :user

  has_one :notification, dependent: :destroy

  validates_uniqueness_of :user, scope: :group,
    message: "is already a member of the group"

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
end
