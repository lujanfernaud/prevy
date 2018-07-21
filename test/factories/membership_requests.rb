# frozen_string_literal: true

# == Schema Information
#
# Table name: membership_requests
#
#  id         :bigint(8)        not null, primary key
#  message    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :bigint(8)
#  user_id    :bigint(8)
#
# Indexes
#
#  index_membership_requests_on_group_id  (group_id)
#  index_membership_requests_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :membership_request do
    group
    user
    message "Factory membership request."
  end
end
