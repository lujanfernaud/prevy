# frozen_string_literal: true

require 'test_helper'

class Groups::MembersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group = groups(:one)
    @phil  = users(:phil)
    @penny = users(:penny)
    @group.members << @penny
  end

  test "should get index" do
    sign_in(@penny)

    get group_members_url(@group)

    assert_response :success
  end

  test "should show user" do
    sign_in(@penny)

    get group_member_url(@group, @phil)

    assert_response :success
  end
end
