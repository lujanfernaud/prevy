require 'test_helper'

class UserGroupCommentsCountTest < ActiveSupport::TestCase
  test "#increase" do
    comments_count = user_group_comments_counts(:one)

    comments_count.increase

    assert_equal 2, comments_count.number
  end

  test "#decrease" do
    comments_count = user_group_comments_counts(:one)

    comments_count.decrease

    assert_equal 0, comments_count.number
  end

  test "#decrease doesn't go below 0" do
    comments_count = user_group_comments_counts(:one)

    comments_count.decrease
    comments_count.decrease

    assert_equal 0, comments_count.number
  end
end
