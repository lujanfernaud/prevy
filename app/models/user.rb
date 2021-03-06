# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  admin                  :boolean          default(FALSE)
#  bio                    :string
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  location               :string
#  name                   :string
#  notifications_count    :integer          default(0), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sample_user            :boolean          default(FALSE)
#  settings               :jsonb            not null
#  sign_in_count          :integer          default(0), not null
#  slug                   :string
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_slug                  (slug)
#

class User < ApplicationRecord
  attribute :skip_sample_content, :boolean

  has_many :owned_groups, class_name: "Group", foreign_key: "user_id",
            dependent: :destroy
  has_many :received_requests, through: :owned_groups

  has_many :group_invitations, dependent: :destroy
  has_many :sent_invitations,  class_name: "GroupInvitation",
            foreign_key: "sender_id"

  has_many :membership_requests, dependent: :destroy
  has_many :sent_requests, through: :membership_requests, source: "group"

  has_many :group_memberships, dependent: :delete_all
  has_many :associated_groups, through: :group_memberships, source: "group"

  has_many :user_roles, dependent: :delete_all
  has_many :roles,      through:   :user_roles

  has_many :user_group_points, dependent: :destroy

  has_many :organized_events, class_name: "Event", foreign_key: "organizer_id",
            dependent: :destroy

  has_many :attendances, foreign_key: "attendee_id", dependent: :destroy
  has_many :attended_events, through: :attendances

  has_many :topics,         dependent: :destroy
  has_many :topic_comments, dependent: :delete_all

  has_many :notifications, dependent: :destroy
  has_many :membership_request_notifications
  has_many :group_membership_notifications
  has_many :group_role_notifications
  has_many :announcement_topic_notifications
  has_many :group_invitation_notifications

  validates :email,    presence: true, email:  true
  validates :name,     presence: true, length: { in: 2..50 }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  before_save   :format_name
  before_update :titleize_location
  before_update :capitalize_bio
  after_create  :create_user_sample_content

  # Devise
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # FriendlyId
  include FriendlyId
  friendly_id :slug_candidates, use: :slugged

  # Rolify
  rolify

  # Storext
  include Storext.model
  #
  # Store typecasted values in 'settings' jsonb column.
  store_attributes :settings do
    membership_request_emails Boolean, default: true
    group_membership_emails   Boolean, default: true
    group_role_emails         Boolean, default: true
    group_event_emails        Boolean, default: true
    group_announcement_emails Boolean, default: true
    group_invitation_emails   Boolean, default: true
  end

  scope :confirmed, -> { where.not(confirmed_at: nil) }

  def sample_group
    owned_groups.where(sample_group: true).first
  end

  def groups
    UserGroupsQuery.call(self)
  end

  def group_roles(group)
    roles.where(resource_id: group).map(&:name)
  end

  def events_from_groups
    Event.where(group_id: groups.distinct.pluck(:id)).upcoming
  end

  def group_points(group)
    user_group_points.find_or_create_by!(group: group)
  end

  def group_points_amount(group)
    group_points(group).amount
  end

  def total_membership_requests
    MembershipRequest.total(self)
  end

  # Devise
  #
  # Used for customized account confirmation.
  # See Users::ConfirmationsController#confirm
  def password_match?
    add_password_match_error if password != password_confirmation

    password == password_confirmation && !password.blank?
  end

  protected

    # Devise
    def after_confirmation
      SupportMailer.welcome(self).deliver_later
    end

    # Devise
    #
    # Used for customized sign up and account confirmation.
    def password_required?
      super if confirmed?
    end

  private

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
      UserSampleContentCreator.call(self)
    end

    def add_password_match_error
      self.errors[:password_confirmation] << "does not match password"
    end

    def should_generate_new_friendly_id?
      slug.blank? || saved_change_to_name?
    end

    def slug_candidates
      [
        :name,
        [:name, :id]
      ]
    end
end
