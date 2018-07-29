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
#  index_topic_comments_on_edited_by_id  (edited_by_id)
#  index_topic_comments_on_topic_id      (topic_id)
#  index_topic_comments_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (topic_id => topics.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :topic_comment do
    user
    topic
    body  "Factory comment."
  end
end
