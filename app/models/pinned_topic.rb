# frozen_string_literal: true

# == Schema Information
#
# Table name: topics
#
#  id                :bigint(8)        not null, primary key
#  announcement      :boolean          default(FALSE)
#  body              :text
#  comments_count    :integer          default(0), not null
#  edited_at         :datetime         not null
#  last_commented_at :datetime
#  priority          :integer          default(0)
#  slug              :string
#  title             :string
#  type              :string           default("Topic")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  edited_by_id      :bigint(8)
#  event_id          :bigint(8)
#  group_id          :bigint(8)
#  user_id           :bigint(8)
#
# Indexes
#
#  index_topics_on_edited_by_id       (edited_by_id)
#  index_topics_on_event_id           (event_id)
#  index_topics_on_group_id           (group_id)
#  index_topics_on_id_and_type        (id,type)
#  index_topics_on_last_commented_at  (last_commented_at)
#  index_topics_on_priority           (priority)
#  index_topics_on_slug               (slug)
#  index_topics_on_user_id            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (user_id => users.id)
#

class PinnedTopic < Topic
  PRIORITY = 1
end
