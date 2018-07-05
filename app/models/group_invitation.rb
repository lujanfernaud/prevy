# frozen_string_literal: true

# == Schema Information
#
# Table name: group_invitations
#
#  id         :bigint(8)        not null, primary key
#  email      :string
#  name       :string
#  token      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :bigint(8)
#  sender_id  :bigint(8)
#  user_id    :bigint(8)
#
# Indexes
#
#  index_group_invitations_on_group_id   (group_id)
#  index_group_invitations_on_sender_id  (sender_id)
#  index_group_invitations_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (user_id => users.id)
#

class GroupInvitation < ApplicationRecord
  belongs_to :group
  belongs_to :sender, class_name: "User"
  belongs_to :user,   optional: true

  validates :email, presence: true, email:  true
  validates :name,  presence: true, length: { in: 2..50 }

  validates_uniqueness_of :email, scope: :group,
                           message: "is already in sent invitations"
  validate :uniqueness_of_user_in_group

  has_secure_token

  before_save :store_user

  private

    def uniqueness_of_user_in_group
      if group.members.include? _user
        errors.add(:user, "is already a group member")
      end
    end

    def _user
      @_user ||= User.find_by(email: email)
    end

    def store_user
      self.user = _user
    end
end
