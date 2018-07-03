# frozen_string_literal: true

require 'test_helper'

class UserGroupPointsTest < ActiveSupport::TestCase
  test "#increase" do
    group_points = user_group_points(:one)

    group_points.increase

    assert_equal 2, group_points.amount
  end

  test "#decrease" do
    group_points = user_group_points(:one)

    group_points.decrease

    assert_equal 0, group_points.amount
  end

  test "#decrease doesn't go below 0" do
    group_points = user_group_points(:one)

    group_points.decrease
    group_points.decrease

    assert_equal 0, group_points.amount
  end
end
