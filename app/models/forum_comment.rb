# frozen_string_literal: true

class ForumComment < ApplicationRecord
  belongs_to :forum_topic
  belongs_to :user

  validates :body, presence: true, length: { minimum: 3 }

  def topic
    forum_topic
  end
end
