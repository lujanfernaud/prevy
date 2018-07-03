# frozen_string_literal: true

# == Schema Information
#
# Table name: topics
#
#  id                :bigint(8)        not null, primary key
#  group_id          :bigint(8)
#  user_id           :bigint(8)
#  title             :string
#  body              :text
#  slug              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  type              :string           default("Topic")
#  event_id          :bigint(8)
#  priority          :integer          default(0)
#  announcement      :boolean          default(FALSE)
#  edited_by_id      :bigint(8)
#  edited_at         :datetime
#  last_commented_at :datetime
#

class Topic < ApplicationRecord
  PRIORITY            = 0
  MINIMUM_BODY_LENGTH = 20
  EDITED_OFFSET_TIME  = 600 # 10 minutes
  POINTS              = 3

  belongs_to :group, touch: true
  belongs_to :user
  belongs_to :edited_by, class_name: "User", optional: true

  has_many   :topic_comments, dependent: :delete_all
  has_many   :notifications,  dependent: :destroy

  validate   :body_length
  validates  :title, presence: true, length: { minimum: 2 }

  before_save    :set_priority
  before_save    :set_default_edited_by, unless: :edited_by
  before_save    :set_edited_at
  before_create  :set_default_last_commented_at
  before_create  -> { user_group_points.increase by: POINTS }
  before_destroy -> { user_group_points.decrease by: POINTS }

  # FriendlyId
  include FriendlyId
  friendly_id :slug_candidates, use: :slugged

  scope :prioritized, -> {
    order(priority: :desc, last_commented_at: :desc).includes(:user)
  }

  scope :normal, -> {
    where(type: "Topic")
  }

  def normal?
    type == "Topic"
  end

  def pinned?
    type == "PinnedTopic"
  end

  def event?
    event_id
  end

  def announcement?
    type == "AnnouncementTopic"
  end

  def type_presentable
    return if type == "Topic"

    type.gsub("Topic", "")
  end

  def comments
    topic_comments.order(:created_at).includes(:user)
  end

  def edited?
    return false if group.sample_group?

    !edited_by_author? || updated_at - created_at > EDITED_OFFSET_TIME
  end

  def edited_by_author?
    user == edited_by
  end

  def last_comment_user
    comments.last.user
  end

  private

    def body_length
      BodyLengthValidator.call(self, length: MINIMUM_BODY_LENGTH)
    end

    def set_priority
      self.priority = topic_type_priority
    end

    def topic_type_priority
      Object.const_get(type)::PRIORITY
    end

    def set_default_edited_by
      self.edited_by = user
    end

    def set_edited_at
      return unless content_changed? || !edited_at

      self.edited_at = Time.current
    end

    def content_changed?
      title_changed? || body_changed?
    end

    def set_default_last_commented_at
      self.last_commented_at = Time.current
    end

    def user_group_points
      UserGroupPoints.find_or_create_by!(user: user, group: group)
    end

    def should_generate_new_friendly_id?
      slug.blank? || saved_change_to_title?
    end

    def slug_candidates
      [
        :title,
        [:title, :group_id],
        [:title, :group_id, :user_id]
      ]
    end

    def group_id
      group.id
    end

    def user_id
      user.id
    end
end
