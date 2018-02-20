class Group < ApplicationRecord
  belongs_to :owner,
    class_name:  "User",
    foreign_key: "user_id"

  has_many :group_memberships, dependent: :destroy
  has_many :members, through: :group_memberships, source: "user"

  has_many :events, dependent: :destroy

  mount_uploader :image, ImageUploader

  validates :name,        presence: true, length: { minimum: 3 }
  validates :description, presence: true, length: { minimum: 70 }
  validates :image,       presence: true
end
