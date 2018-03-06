class GroupMembership < ApplicationRecord
  belongs_to :user
  belongs_to :group

  has_one :notification, dependent: :destroy
end
