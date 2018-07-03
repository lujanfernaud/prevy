# frozen_string_literal: true
# == Schema Information
#
# Table name: groups
#
#  id                            :bigint(8)        not null, primary key
#  all_members_can_create_events :boolean          default(FALSE)
#  description                   :string
#  hidden                        :boolean          default(FALSE)
#  image                         :string
#  location                      :string
#  name                          :string
#  sample_group                  :boolean          default(FALSE)
#  slug                          :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  user_id                       :bigint(8)
#
# Indexes
#
#  index_groups_on_location  (location)
#  index_groups_on_slug      (slug)
#  index_groups_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class Group < ApplicationRecord
  SPECIAL_ROLES        = ["organizer", "moderator"].freeze
  RECENT_MEMBERS_SHOWN = 8
  TOP_MEMBERS_SHOWN    = 12

  belongs_to :owner, class_name: "User", foreign_key: "user_id"

  has_one  :image_placeholder, as: :resource, dependent: :destroy

  has_many :group_memberships, dependent: :delete_all
  has_many :members, through: :group_memberships, source: "user"

  has_many :user_group_points, dependent: :destroy

  has_many :membership_requests, dependent: :destroy
  has_many :received_requests, through: :membership_requests, source: "user"

  has_many :events, dependent: :destroy

  has_many :topics,              dependent: :destroy
  has_many :pinned_topics,       dependent: :destroy
  has_many :event_topics,        dependent: :destroy
  has_many :announcement_topics, dependent: :destroy

  has_many :notifications, dependent: :destroy

  validates :description, presence: true, length: { minimum: 70 }
  validates :image,       presence: true
  validates :location,    presence: true, length: { minimum: 3 }
  validates :name,        presence: true, length: { minimum: 3 }

  before_save    :prepare_text_fields
  after_create   :add_owner_as_organizer_and_moderator
  after_create   :create_owner_group_points
  after_update   :update_members_role
  after_save     :create_image_placeholder
  before_destroy :destroy_owner_group_points

  # CarrierWave
  mount_uploader :image, ImageUploader
  include CarrierWave::ImageLocation
  include CarrierWave::SampleImage

  # FriendlyId
  include FriendlyId
  friendly_id :slug_candidates, use: :slugged

  # PgSearch
  include PgSearch

  # Rolify
  resourcify

  pg_search_scope :search,
    against: [:name, :location, :description],
    using:   { tsearch: { prefix: true } }

  scope :random_selection, -> (groups_number) {
    random_offset = rand(1..self.count - groups_number)

    offset(random_offset).limit(groups_number)
  }

  scope :unhidden, -> {
    where(hidden: false, sample_group: false)
  }

  scope :unhidden_without, -> (group) {
    where(hidden: false, sample_group: false).
    where.not(id: group.id)
  }

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

  # When we pass NULL to LIMIT, Postgres treats it as LIMIT ALL (no limit).
  # https://www.postgresql.org/docs/current/static/sql-select.html#SQL-LIMIT
  def topics_prioritized(normal_topics_limit: nil)
    remove_priority_to_past_events_topics

    ids = topic_ids(normal_topics_limit)

    topics.where(id: ids).prioritized
  end

  def normal_topics
    topics.normal.prioritized
  end

  def organizers
    User.joins(:roles).where(roles: { resource_id: self, name: "organizer" })
  end

  def moderators
    User.joins(:roles).where(roles: { resource_id: self, name: "moderator" })
  end

  def members_with_role
    User.joins(:roles).where(roles: { resource_id: self, name: "member" })
  end

  def recent_members
    members.limit(RECENT_MEMBERS_SHOWN)
  end

  def top_members(limit: TOP_MEMBERS_SHOWN)
    members_with_role.
     joins(:user_group_points).
     where("user_group_points.group_id = ?", self).
     order("user_group_points.amount DESC").
     limit(limit)
  end

  def add_to_organizers(member)
    add_role_to member, role: :organizer
  end

  def remove_from_organizers(member)
    remove_role_from member, role: :organizer
  end

  def add_to_moderators(member)
    add_role_to member, role: :moderator
  end

  def remove_from_moderators(member)
    remove_role_from member, role: :moderator
  end

  def user_is_authorized?(user)
    return false unless members.include?(user) || owner == user

    self == user.sample_group || user.confirmed?
  end

  private

    def prepare_text_fields
      self.name = name.titleize
      self.location = location.titleize
      self.description = description[0].capitalize + description[1..-1]
    end

    def create_owner_group_points
      UserGroupPoints.create!(user: owner, group: self)
    end

    def destroy_owner_group_points
      group_points = UserGroupPoints.find_by(user: owner, group: self)

      return unless group_points

      group_points.destroy
    end

    def add_owner_as_organizer_and_moderator
      owner.add_role :organizer, self
      owner.add_role :moderator, self
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

    def add_role_to(member, role:)
      if has_member_role? member
        change_role_for member, remove_as: :member, add_as: role
      else
        member.add_role role, self
      end
    end

    def has_member_role?(member)
      member.has_role? :member, self
    end

    def change_role_for(member, remove_as:, add_as:)
      member.remove_role remove_as, self
      member.add_role add_as, self
    end

    def remove_role_from(member, role:)
      if only_has_one_special_role? member
        change_role_for member, remove_as: role, add_as: :member
      else
        member.remove_role role, self
      end
    end

    def only_has_one_special_role?(member)
      !(SPECIAL_ROLES - member.group_roles(self)).empty?
    end

    def create_image_placeholder
      ImagePlaceholderCreator.new(self).call
    end

    def remove_priority_to_past_events_topics
      return if event_topics_to_remove_priority.empty?

      event_topics_to_remove_priority.update_all(priority: 0)
    end

    def event_topics_to_remove_priority
      past_event_ids = events.past.pluck(:id)

      topics.where("event_id IN (?)", past_event_ids)
    end

    def topic_ids(normal_topics_limit)
      special_topics_ids = special_topics.pluck(:id)
      normal_topics_ids  = normal_topics.limit(normal_topics_limit).pluck(:id)

      special_topics_ids + normal_topics_ids
    end

    def special_topics
      Topic.where(group: self).where.not(type: "Topic").prioritized
    end

    def should_generate_new_friendly_id?
      slug.blank? || saved_change_to_name?
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
end
