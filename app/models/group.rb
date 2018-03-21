class Group < ApplicationRecord
  resourcify
  after_create :add_owner_as_organizer

  belongs_to :owner, class_name: "User", foreign_key: "user_id"

  has_many :group_memberships, dependent: :destroy
  has_many :members, through: :group_memberships, source: "user"

  has_many :membership_requests, dependent: :destroy
  has_many :received_requests, through: :membership_requests, source: "user"

  has_many :events, dependent: :destroy

  has_many :notifications, dependent: :destroy

  mount_uploader :image, ImageUploader

  validates :name,        presence: true, length: { minimum: 3 }
  validates :description, presence: true, length: { minimum: 70 }
  validates :image,       presence: true

  def organizers
    User.with_role(:organizer, self).reverse
  end

  def members_with_role
    User.with_role(:member, self).reverse
  end

  private

    def add_owner_as_organizer
      owner.add_role(:organizer, self)
    end
end
