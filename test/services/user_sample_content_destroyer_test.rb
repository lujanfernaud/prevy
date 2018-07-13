# frozen_string_literal: true

require 'test_helper'

class UserSampleContentDestroyerTest < ActiveSupport::TestCase
  test "destroys user sample content if present and returns true" do
    user = create :user

    assert UserSampleContentDestroyer.call(user)

    assert_not user.sample_group
  end

  test "returns false if user has no sample content" do
    user = create :user, skip_sample_content: true

    assert_not UserSampleContentDestroyer.call(user)
  end
end
