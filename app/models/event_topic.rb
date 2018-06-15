# frozen_string_literal: true

class EventTopic < Topic
  PRIORITY = 1

  belongs_to :event, touch: true

  before_save :set_priority

  private

    def set_priority
      self.priority = PRIORITY
    end
end
