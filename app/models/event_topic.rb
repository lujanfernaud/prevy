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


class EventTopic < Topic
  PRIORITY = 2

  belongs_to :event, touch: true

  private

    def slug_candidates
      [
        :title,
        [:title, :event_start_date],
        [:title, :event_start_date, :group_id]
      ]
    end

    def event_start_date
      event.start_date.strftime("%b %d %Y")
    end
end
