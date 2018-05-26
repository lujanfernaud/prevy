class Group < ApplicationRecord
  include PgSearch

  include FriendlyId
  friendly_id :slug_candidates, use: :slugged

  resourcify

  before_save  :titleize_name
  before_save  :titleize_location
  before_save  :capitalize_description
  after_create :add_owner_as_organizer
  after_update :update_members_role
  after_save   :create_image_placeholder

  belongs_to :owner, class_name: "User", foreign_key: "user_id"

  has_many :group_memberships, dependent: :destroy
  has_many :members, through: :group_memberships, source: "user"

  has_many :membership_requests, dependent: :destroy
  has_many :received_requests, through: :membership_requests, source: "user"

  has_many :events, dependent: :destroy

  has_many :notifications, dependent: :destroy

  has_one  :image_placeholder, as: :resource, dependent: :destroy

  validates :name,        presence: true, length: { minimum: 3 }
  validates :location,    presence: true, length: { minimum: 3 }
  validates :description, presence: true, length: { minimum: 70 }
  validates :image,       presence: true

  pg_search_scope :search,
    against: [:name, :location, :description],
    using: { tsearch: { prefix: true } }

  scope :unhidden, -> {
    where(hidden: false, sample_group: false)
  }

  scope :unhidden_without, -> (group) {
    where(hidden: false, sample_group: false).
    where.not(id: group.id)
  }

  scope :random_selection, -> (groups_number) {
    random_offset = rand(1..self.count - groups_number)

    offset(random_offset).limit(groups_number)
  }

  mount_uploader :image, ImageUploader
  include CarrierWave::ImageLocation
  include CarrierWave::SampleImage

  def image_base64
    return image_url(:thumb) unless image_placeholder

    image_placeholder.image_base64
  end

  def sample_resource?
    sample_group?
  end

  def user_sample_resource?
    sample_resource? && name =~ /\ASample\s/
  end

  def recent_organizers
    organizers.last(3).reverse
  end

  def recent_members_with_role
    members_with_role.last(3).reverse
  end

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

    def should_generate_new_friendly_id?
      name_changed?
    end

    def slug_candidates
      [
        :name,
        [:name, :location],
        [:name, :location, :owner_name],
        [:name, :location, :owner_name, :owner_id]
      ]
    end

    def owner_name
      owner.name
    end

    def owner_id
      owner.id
    end

    def titleize_name
      self.name = name.titleize
    end

    def titleize_location
      self.location = location.titleize
    end

    def capitalize_description
      self.description = description[0].capitalize + description[1..-1]
    end

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
      member.touch
    end

    def create_image_placeholder
      ImagePlaceholderCreator.new(self).call
    end
end
