# frozen_string_literal: true

class Topic < ApplicationRecord
  MINIMUM_BODY_LENGTH = 20
  EDITED_OFFSET_TIME  = 600 # 10 minutes

  include FriendlyId
  friendly_id :slug_candidates, use: :scoped, scope: :group

  belongs_to :group
  belongs_to :user
  belongs_to :edited_by, class_name: "User", optional: true

  has_many :topic_comments, dependent: :destroy
  has_many :notifications,  dependent: :destroy

  validates :title, presence: true, length: { minimum: 2 }
  validate  :body_length

  before_save :set_default_edited_by, unless: :edited_by

  scope :prioritized, -> {
    order(priority: :desc, updated_at: :desc).includes(:user)
  }

  scope :normal, -> {
    where(type: nil)
  }

  scope :events, -> {
    where(type: "EventTopic")
  }

  scope :announcements, -> {
    where(type: "AnnouncementTopic")
  }

  def normal?
    !type
  end

  def type_presentable
    return unless type

    type.gsub("Topic", "")
  end

  def comments
    topic_comments.order(:created_at).includes(:user)
  end

  def edited?
    !edited_by_author? || updated_at - created_at > EDITED_OFFSET_TIME
  end

  def edited_by_author?
    user == edited_by
  end

  private

    def body_length
      BodyLengthValidator.call(self, length: MINIMUM_BODY_LENGTH)
    end

    def set_default_edited_by
      self.edited_by = user
    end

    def should_generate_new_friendly_id?
      title_changed?
    end

    def slug_candidates
      [
        :title,
        [:title, :date]
      ]
    end

    def date
      Time.zone.now.strftime("%b %d %Y")
    end
end
