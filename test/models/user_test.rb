require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "is valid" do
    user = users(:phil)
    assert user.valid?
  end

  test "is invalid without name" do
    user = users(:phil)
    user.name = ""

    refute user.valid?
  end

  test "is invalid with short name" do
    user = users(:phil)
    user.name = "Ph"

    refute user.valid?
  end

  test "is invalid without email" do
    user = users(:phil)
    user.email = ""

    refute user.valid?
  end

  test "is invalid with bad email" do
    user = users(:phil)
    user.email = "phil.example.com"

    refute user.valid?

    user.email = "@example.com"

    refute user.valid?

    user.email = "phil@example"

    refute user.valid?
  end

  test "is invalid with short password" do
    user = users(:phil)
    user.password = "passw"

    refute user.valid?
  end

  test ".recent returns newest 5 users" do
    newest_users = [users(:penny),
                    users(:user_0),
                    users(:user_1),
                    users(:user_2),
                    users(:phil)]

    assert_equal User.recent, newest_users
  end
end
