# frozen_string_literal: true

class TopicComment < ApplicationRecord
  belongs_to :topic, touch: true
  belongs_to :user

  validates :body, presence: true, length: { minimum: 3 }
end
