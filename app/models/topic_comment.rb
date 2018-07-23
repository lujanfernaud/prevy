# frozen_string_literal: true

# == Schema Information
#
# Table name: topic_comments
#
#  id           :bigint(8)        not null, primary key
#  body         :text
#  edited_at    :datetime         not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  edited_by_id :bigint(8)
#  topic_id     :bigint(8)
#  user_id      :bigint(8)
#
# Indexes
#
#  index_topic_comments_on_topic_id  (topic_id)
#  index_topic_comments_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (topic_id => topics.id)
#  fk_rails_...  (user_id => users.id)
#

class TopicComment < ApplicationRecord
  MINIMUM_BODY_LENGTH = 2
  EDITED_OFFSET_TIME  = 300 # 5 minutes
  POINTS              = 1

  belongs_to :topic, touch: true, counter_cache: :comments_count
  belongs_to :user,  touch: true
  belongs_to :edited_by, class_name: "User", optional: true

  validate :body_length

  before_save    :set_default_edited_by, unless: :edited_by
  before_save    :set_edited_at
  after_create   :update_topic_last_commented_at_date
  before_create  -> { user_group_points.increase by: POINTS }
  before_destroy -> { user_group_points.decrease by: POINTS }

  def edited?
    !edited_by_author? || edited_at - created_at > EDITED_OFFSET_TIME
  end

  def edited_by_author?
    user == edited_by
  end

  def group
    topic.group
  end

  private

    def body_length
      BodyLengthValidator.call(self, length: MINIMUM_BODY_LENGTH)
    end

    def set_default_edited_by
      self.edited_by = user
    end

    def set_edited_at
      return unless body_changed?

      self.edited_at = Time.current
    end

    def update_topic_last_commented_at_date
      topic.update_attributes(last_commented_at: created_at)
    end

    def user_group_points
      UserGroupPoints.find_or_create_by!(user: user, group: topic.group)
    end
end
