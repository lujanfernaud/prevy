require 'test_helper'

class GroupsSearchTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:penny)
  end

  test "user can search for a group using only the location" do
    log_in_as(@user)
    visit root_path

    search_using_only_location "Portland"
    assert page.has_content?   "6 groups found"

    search_using_only_location "Kyoto"
    assert page.has_content?   "1 group found"
  end

  test "user can search for a group using only the group's name" do
    log_in_as(@user)
    visit root_path

    search_using_only_group  "Nike"
    assert page.has_content? "1 group found"

    search_using_only_group  "Stranger's Group"
    assert page.has_content? "1 group found"
  end

  test "user can search for a group using the location and group's name" do
    log_in_as(@user)
    visit root_path

    search location: "Kyoto", group: "Sakura"
    assert page.has_content? "1 group found"

    search location: "Portland", group: "Woodell's Group"
    assert page.has_content? "1 group found"
  end

  test "user can search for a group using a partial string" do
    log_in_as(@user)
    visit root_path

    search location: "Port", group: "Gr"
    assert page.has_content? "5 groups found"

    search location: "Kyo", group: ""
    assert page.has_content? "1 group found"
  end

  test "user can search in a different case" do
    log_in_as(@user)
    visit root_path

    search location: "", group: "sakura"
    assert page.has_content? "1 group found"

    search location: "portland", group: ""
    assert page.has_content? "6 groups found"
  end

  private

    def search_using_only_location(location)
      search location: location, group: ""
    end

    def search_using_only_group(group)
      search location: "", group: group
    end

    def search(location:, group:)
      fill_in "Location", with: location
      fill_in "Group", with: group
      click_on "Search"
    end
end
