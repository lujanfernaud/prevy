class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  include FriendlyId
  friendly_id :slug_candidates, use: :slugged

  before_save   :format_name
  before_update :titleize_location
  before_update :capitalize_bio
  after_create  :create_user_sample_content

  rolify

  include Storext.model

  store_attributes :settings do
    membership_request_emails Boolean, default: true
    group_membership_emails   Boolean, default: true
    group_role_emails         Boolean, default: true
    group_event_emails        Boolean, default: true
  end

  has_many :owned_groups, class_name: "Group", foreign_key: "user_id",
    dependent: :destroy
  has_many :received_requests, through: :owned_groups

  has_many :membership_requests, dependent: :destroy
  has_many :sent_requests, through: :membership_requests, source: "group"

  has_many :group_memberships
  has_many :associated_groups, through: :group_memberships, source: "group"

  has_many :organized_events, class_name: "Event", foreign_key: "organizer_id"

  has_many :attendances, foreign_key: "attendee_id"
  has_many :attended_events, through: :attendances

  has_many :topics, dependent: :destroy
  has_many :topic_comments, dependent: :destroy

  has_many :notifications, dependent: :destroy
  has_many :membership_request_notifications
  has_many :group_membership_notifications
  has_many :group_role_notifications

  validates :name, presence: true, length: { in: 3..50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  scope :recent, -> (users_number = 5) {
    order("created_at DESC").limit(users_number)
  }

  def sample_group
    owned_groups.where(sample_group: true).first
  end

  def groups
    Group.includes(:group_memberships)
         .where(
           'groups.user_id = :user OR group_memberships.user_id = :user',
            user: self
         )
         .references(:group_memberships)
  end

  def events_from_groups
    Event.where(group_id: groups.map(&:id)).upcoming
  end

  def total_membership_requests
    received_requests + sent_requests
  end

  # I haven't found a better way of including the related tables for each
  # resource when using STI. This may mean that STI is not the best solution
  # for this case.
  #
  # We could use a lambda for each has_many, but as we still need to call
  # notifications_optimized, I think this solution looks cleaner.
  def notifications_optimized
    membership_request_notifications.includes(:membership_request) +
      group_membership_notifications.includes(group_membership: :group) +
      group_role_notifications.includes(:group)
  end

  def upcoming_attended_events
    attended_events.upcoming.three
  end

  def password_required?
    super if confirmed?
  end

  def password_match?
    add_password_match_error if password != password_confirmation

    password == password_confirmation && !password.blank?
  end

  private

    def should_generate_new_friendly_id?
      name_changed?
    end

    def slug_candidates
      [
        :name,
        [:name, :id]
      ]
    end

    def format_name
      self.name = NameFormatter.call(name)
    end

    def titleize_location
      return unless location

      self.location = location.titleize
    end

    def capitalize_bio
      return unless bio && !bio.empty?

      self.bio = bio[0].capitalize + bio[1..-1]
    end

    def create_user_sample_content
      return if user_without_sample_content?

      create_sample_group
      create_sample_membership_request
    end

    def user_without_sample_content?
      self.sample_user? || self.admin?
    end

    def create_sample_group
      SampleGroup.create_for_user(self)
    end

    def create_sample_membership_request
      SampleMembershipRequest.create_for_user(self)
    end

    def add_password_match_error
      self.errors[:password_confirmation] << "does not match password"
    end
end
