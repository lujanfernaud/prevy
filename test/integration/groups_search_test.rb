require 'test_helper'

class GroupsSearchTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:penny)
  end

  test "user can search for a group using only the city" do
    log_in_as(@user)
    visit root_path

    fill_in "Location", with: "Portland"
    fill_in "Group", with: ""
    click_on "Search"

    assert page.has_content? "6 groups found"

    fill_in "Location", with: "Kyoto"
    fill_in "Group", with: ""
    click_on "Search"

    assert page.has_content? "1 group found"
  end

  test "user can search for a group using only the group's name" do
    log_in_as(@user)
    visit root_path

    fill_in "Location", with: ""
    fill_in "Group", with: "Nike"
    click_on "Search"

    assert page.has_content? "1 group found"

    fill_in "Location", with: ""
    fill_in "Group", with: "Stranger's Group"
    click_on "Search"

    assert page.has_content? "1 group found"
  end

  test "user can search for a group using the city and group's name" do
    log_in_as(@user)
    visit root_path

    fill_in "Location", with: "Kyoto"
    fill_in "Group", with: "Sakura"
    click_on "Search"

    assert page.has_content? "1 group found"
  end

  test "user can search for a group using a partial string" do
    log_in_as(@user)
    visit root_path

    fill_in "Location", with: "Port"
    fill_in "Group", with: "Gr"
    click_on "Search"

    assert page.has_content? "5 groups found"

    fill_in "Location", with: "Kyo"
    fill_in "Group", with: ""
    click_on "Search"

    assert page.has_content? "1 group found"
  end

  test "user can search in a different case" do
    log_in_as(@user)
    visit root_path

    fill_in "Location", with: ""
    fill_in "Group", with: "Sakura"
    click_on "Search"

    assert page.has_content? "1 group found"

    fill_in "Location", with: ""
    fill_in "Group", with: "Stranger"
    click_on "Search"

    assert page.has_content? "1 group found"
  end
end
