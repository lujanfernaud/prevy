class Group < ApplicationRecord
  resourcify
  after_create :add_owner_as_organizer
  after_update :update_members_role

  belongs_to :owner, class_name: "User", foreign_key: "user_id"

  has_many :group_memberships, dependent: :destroy
  has_many :members, through: :group_memberships, source: "user"

  has_many :membership_requests, dependent: :destroy
  has_many :received_requests, through: :membership_requests, source: "user"

  has_many :events, dependent: :destroy

  has_many :notifications, dependent: :destroy

  mount_uploader :image, ImageUploader

  validates :name,        presence: true, length: { minimum: 3 }
  validates :location,    presence: true, length: { minimum: 3 }
  validates :description, presence: true, length: { minimum: 70 }
  validates :image,       presence: true

  scope :search, -> (location, group_name) {
    where("lower(location) LIKE :location AND lower(name) LIKE :name",
      location: "%#{location.downcase}%", name: "%#{group_name.downcase}%")
  }

  scope :unhidden, -> {
    where(hidden: false, sample_group: false)
  }

  scope :random_selection, -> {
    groups_number = 3
    offset_number = rand(1..self.count - groups_number)

    offset(offset_number).limit(groups_number)
  }

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

    def update_members_role
      return unless saved_change_to_all_members_can_create_events?

      if all_members_can_create_events
        add_members_to_organizers
      else
        remove_members_from_organizers
      end
    end

    def add_members_to_organizers
      members.each do |member|
        change_role_for member, remove_as: :member, add_as: :organizer
      end
    end

    def remove_members_from_organizers
      members.each do |member|
        change_role_for member, remove_as: :organizer, add_as: :member
      end
    end

    def change_role_for(member, remove_as:, add_as:)
      member.remove_role remove_as, self
      member.add_role add_as, self
    end
end
