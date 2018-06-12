# frozen_string_literal: true

class TopicComment < ApplicationRecord
  MINIMUM_BODY_LENGTH = 2
  EDITED_OFFSET_TIME  = 300 # 5 minutes

  belongs_to :topic, touch: true
  belongs_to :user

  validate :body_length

  def edited?
    updated_at - created_at > EDITED_OFFSET_TIME
  end

  private

    def body_length
      BodyLengthValidator.call(self, length: MINIMUM_BODY_LENGTH)
    end
end
