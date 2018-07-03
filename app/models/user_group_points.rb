# frozen_string_literal: true
# == Schema Information
#
# Table name: user_group_points
#
#  id         :bigint(8)        not null, primary key
#  amount     :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :bigint(8)
#  user_id    :bigint(8)
#
# Indexes
#
#  index_user_group_points_on_group_id  (group_id)
#  index_user_group_points_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id) ON DELETE => cascade
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade
#

class UserGroupPoints < ApplicationRecord
  belongs_to :user
  belongs_to :group

  def increase(by: 1)
    increment!(:amount, by)
  end

  def decrease(by: 1)
    return if amount.zero?

    decrement!(:amount, by)
  end
end
