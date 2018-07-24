# frozen_string_literal: true

require 'test_helper'

class Groups::InvitationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    stub_sample_content_for_new_users

    @group = create :group
  end

  test "should get index" do
    sign_in @group.owner

    get group_invitations_url(@group)

    assert_response :success
  end

  test "should get new" do
    sign_in @group.owner

    get new_group_invitation_url(@group)

    assert_response :success
  end

  test "should create invitation" do
    sign_in @group.owner

    NewGroupInvitationNotifier.expects(:call)

    assert_difference('GroupInvitation.count') do
      post group_invitations_url(@group), params: invitation_params
    end

    assert_redirected_to group_invitations_url(@group)
  end

  private

    def invitation_params
      {
        group_invitation: {
          name:  "Doris",
          email: "doris@test.test"
        }
      }.merge(group: @group, sender: @group.owner)
    end
end
