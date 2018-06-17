# frozen_string_literal: true

class TopicComment < ApplicationRecord
  MINIMUM_BODY_LENGTH = 2
  EDITED_OFFSET_TIME  = 300 # 5 minutes

  belongs_to :topic, touch: true
  belongs_to :user
  belongs_to :edited_by, class_name: "User", optional: true

  validate :body_length

  before_save  :set_default_edited_by, unless: :edited_by
  after_create :update_topic_last_commented_at_date

  def edited?
    !edited_by_author? || updated_at - created_at > EDITED_OFFSET_TIME
  end

  def edited_by_author?
    user == edited_by
  end

  def edited_at
    updated_at
  end

  private

    def body_length
      BodyLengthValidator.call(self, length: MINIMUM_BODY_LENGTH)
    end

    def set_default_edited_by
      self.edited_by = user
    end

    def update_topic_last_commented_at_date
      topic.last_commented_at = created_at
    end
end
