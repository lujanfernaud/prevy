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


class AnnouncementTopic < Topic
  PRIORITY = 3

  after_create :notify_group_members

  private

    def notify_group_members
      return if group.sample_group?

      NewAnnouncementNotification.call(self)
    end

    def slug_candidates
      [
        :title,
        [:title, :date],
        [:title, :date, :group_id]
      ]
    end

    def date
      Time.zone.now.strftime("%b %d %Y")
    end
end
