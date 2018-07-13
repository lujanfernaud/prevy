# frozen_string_literal: true

require 'test_helper'

class Groups::InvitedMembersControllerTest < ActionDispatch::IntegrationTest
  def setup
    stub_sample_content_for_new_users

    @group = create :group
  end

  test "create membership for registered user" do
    user       = create :user
    invitation = create :group_invitation,
                         group:  @group,
                         sender: @group.owner,
                         email:  user.email

    UserSampleContentDestroyer.expects(:call).with(user)

    post group_invited_members_path(@group, token: invitation.token)

    assert @group.members.include? user
    assert_redirected_to group_path(@group, invited: true)
  end

  test "create account and membership for new user" do
    invitation = create :group_invitation,
                         group:  @group,
                         sender: @group.owner,
                         email:  "jojo@prevy.test"

    post group_invited_members_path(@group, token: invitation.token)

    user = User.find_by(email: "jojo@prevy.test")

    assert @group.members.include?     user
    assert @group.invitations.include? invitation
    assert_redirected_to user_confirmation_path invited_user_params(invitation)
  end

  test "created but not confirmed user is redirected again to confirmation" do
    invitation = create :group_invitation,
                         group:  @group,
                         sender: @group.owner,
                         email:  "jojo@prevy.test"

    post group_invited_members_path(@group, token: invitation.token)

    post group_invited_members_path(@group, token: invitation.token)

    assert_redirected_to user_confirmation_path invited_user_params(invitation)
  end

  private

    def invited_user_params(invitation)
      {
        confirmation_token: invitation.token,
        group_id:           invitation.group.id,
        invited:            true
      }
    end
end
