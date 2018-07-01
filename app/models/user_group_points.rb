# frozen_string_literal: true

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
