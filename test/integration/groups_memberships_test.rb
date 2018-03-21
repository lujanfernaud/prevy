require 'test_helper'

class GroupsMembershipsTest < ActionDispatch::IntegrationTest
  def setup
    @public_group  = groups(:public)
    @private_group = groups(:three)
  end

  test "logged in user joins public group" do
    user = users(:stranger)

    log_in_as(user)

    visit group_path(@public_group)

    click_on "Join group"

    assert user.has_role? :member, @public_group
    assert page.has_content? "You are now a member of #{@public_group.name}!"
    assert current_path == group_path(@public_group)
  end
end
