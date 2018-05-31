# frozen_string_literal: true

class TopicComment < ApplicationRecord
  MINIMUM_BODY_LENGTH = 2

  belongs_to :topic, touch: true
  belongs_to :user

  validate :body_length

  private

    def body_length
      BodyLengthValidator.call(self, length: MINIMUM_BODY_LENGTH)
    end
end
