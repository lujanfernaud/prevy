# == Schema Information

#
# Table name: group_invitations
#
#  id         :bigint(8)        not null, primary key
#  email      :string
#  name       :string
#  token      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :bigint(8)
#  sender_id  :bigint(8)
#  user_id    :bigint(8)
#
# Indexes
#
#  index_group_invitations_on_group_id   (group_id)
#  index_group_invitations_on_sender_id  (sender_id)
#  index_group_invitations_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :group_invitation do
    group
    sender
    user
    sequence(:name)  { |n| "Invited User #{n}" }
    sequence(:email) { |n| "inviteduser#{n}@test.test" }
    token            nil
  end
end
