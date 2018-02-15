require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  test "user visits profile" do
    user = users(:phil)

    visit user_path(user)

    assert page.has_content? user.name
    assert page.has_css?     "img"
    assert page.has_content? "Location"
    assert page.has_content? user.location
    assert page.has_content? "Bio"
    assert page.has_content? user.bio
    assert page.has_content? "Organized"
    assert page.has_css?     ".box"
  end

  test "profile shows 'Organized'" do
    user = users(:penny)

    visit user_path(user)

    assert page.has_content? "Organized"
  end

  test "profile shows 'Organized (last 3)'" do
    user = users(:phil)

    visit user_path(user)

    assert page.has_content? "Organized (last 3)"
  end

  test "profile does not show 'Organized'" do
    user = users(:woodell)

    visit user_path(user)

    assert_not page.has_content? "Organized"
  end

  test "profile shows edit link for logged in user" do
    phil = users(:phil)

    log_in_as(phil)

    visit user_path(phil)

    assert page.has_content? "Edit profile"
  end

  test "profile does not show edit link for other users" do
    phil  = users(:phil)
    penny = users(:penny)

    log_in_as(phil)

    visit user_path(penny)

    assert_not page.has_content? "Edit profile"
  end
end
