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
