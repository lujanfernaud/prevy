class MembershipRequest < ApplicationRecord
  belongs_to :group
  belongs_to :user

  validates_uniqueness_of :user, scope: :group,
    message: "is already a member of the group"
end
