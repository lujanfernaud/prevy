class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  rolify

  include Storext.model

  store_attributes :settings do
    membership_request_emails Boolean, default: true
    group_membership_emails   Boolean, default: true
    group_role_emails         Boolean, default: true
  end

  has_many :owned_groups, class_name: "Group", foreign_key: "user_id"
  has_many :received_requests, through: :owned_groups

  has_many :membership_requests, dependent: :destroy
  has_many :sent_requests, through: :membership_requests, source: "group"

  has_many :group_memberships
  has_many :associated_groups, through: :group_memberships, source: "group"

  has_many :organized_events, class_name: "Event", foreign_key: "organizer_id"

  has_many :attendances, foreign_key: "attendee_id"
  has_many :attended_events, through: :attendances

  has_many :notifications, dependent: :destroy

  validates :name, presence: true, length: { in: 3..50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  scope :recent, -> {
    order("created_at DESC").limit(5)
  }

  def groups
    Group.includes(:group_memberships)
         .where(
           'groups.user_id = :user OR group_memberships.user_id = :user',
            user: self
         )
         .references(:group_memberships)
  end

  def total_membership_requests
    received_requests + sent_requests
  end

  def past_attended_events
    attended_events.past.three
  end

  def upcoming_attended_events
    attended_events.upcoming.three
  end

  def last_organized_events
    organized_events.three
  end
end
