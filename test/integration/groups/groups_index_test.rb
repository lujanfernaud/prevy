require 'test_helper'

class GroupsIndexTest < ActionDispatch::IntegrationTest
  def setup
    @phil = users(:phil)
    @onitsuka = users(:onitsuka)
  end

  test "user visits groups index" do
    groups = Group.unhidden

    visit groups_path

    groups.each do |group|
      assert page.has_css? ".group-box"
      assert page.has_link? group.name
    end
  end

  test "group card shows members count" do
    group = create :group, owner: @phil

    log_in_as @onitsuka

    visit groups_path

    within "#group-#{group.id}" do
      refute page.has_link? "topics"
      assert page.has_content? "members"
    end
  end
end
