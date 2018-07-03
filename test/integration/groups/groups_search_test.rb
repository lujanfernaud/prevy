# frozen_string_literal: true

require 'test_helper'

class GroupsSearchTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:penny)
  end

  test "search using location as keyword" do
    log_in_as(@user)
    visit groups_path

    search "Portland"
    assert page.has_content? "3 groups found"
  end

  test "search using name as keyword" do
    log_in_as(@user)
    visit groups_path

    search "Sakura"
    assert page.has_content? "1 group found"
  end

  test "search using partial keyword" do
    log_in_as(@user)
    visit groups_path

    search "Portl"
    assert page.has_content? "3 groups found"
  end

  test "search using name and description as keyword" do
    log_in_as(@user)
    visit groups_path

    search "Nike"
    assert page.has_content? "3 groups found"
  end

  test "search using two keywords" do
    log_in_as(@user)
    visit groups_path

    search "Nike Portland"
    assert page.has_content? "3 groups found"
  end

  test "search using two partial keywords" do
    log_in_as(@user)
    visit groups_path

    search "Nik Portl"
    assert page.has_content? "3 groups found"
  end

  test "search using three keywords" do
    log_in_as(@user)
    visit groups_path

    search "Nike Portland Penny"
    assert page.has_content? "1 group found"
  end

  test "search using three partial keywords" do
    log_in_as(@user)
    visit groups_path

    search "Nik Portl Penn"
    assert page.has_content? "1 group found"
  end

  test "search for hidden group returns nothing" do
    log_in_as(@user)
    visit groups_path

    search "Stranger's Group"
    assert page.has_content? "0 groups found"
  end

  private

    def search(keywords)
      fill_in "keywords", with: keywords
      click_on "Search"
    end
end
