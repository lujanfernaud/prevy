class Group < ApplicationRecord
  include PgSearch

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

  pg_search_scope :search, against: [:name, :location, :description]

  scope :unhidden, -> {
    where(hidden: false, sample_group: false)
  }

  scope :random_selection, -> (groups_number) {
    random_offset = rand(1..self.count - groups_number)

    offset(random_offset).limit(groups_number)
  }

  def organizers
    User.with_role(:organizer, self).reverse
  end

  def members_with_role
    User.with_role(:member, self).reverse
  end

  def add_to_organizers(member)
    change_role_for member, remove_as: :member, add_as: :organizer
  end

  def remove_from_organizers(member)
    change_role_for member, remove_as: :organizer, add_as: :member
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
      members.each { |member| add_to_organizers(member) }
    end

    def remove_members_from_organizers
      members.each { |member| remove_from_organizers(member) }
    end

    def change_role_for(member, remove_as:, add_as:)
      member.remove_role remove_as, self
      member.add_role add_as, self
    end
end
