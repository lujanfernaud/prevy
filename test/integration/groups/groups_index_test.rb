require 'test_helper'

class GroupsIndexTest < ActionDispatch::IntegrationTest
  test "user visits groups index" do
    groups = Group.where(hidden: false)

    visit groups_path

    groups.each do |group|
      assert page.has_css? ".group-box"
      assert page.has_link? group.name
    end
  end
end
