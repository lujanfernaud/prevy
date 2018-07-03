# frozen_string_literal: true

# == Schema Information
#
# Table name: user_group_points
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)
#  group_id   :bigint(8)
#  amount     :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
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
