class UserGroupCommentsCount < ApplicationRecord
  belongs_to :user
  belongs_to :group

  def number
    comments_count
  end

  def increase
    increment!(:comments_count)
  end

  def decrease
    return if comments_count.zero?

    decrement!(:comments_count)
  end
end
