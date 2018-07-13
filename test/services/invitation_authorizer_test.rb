# frozen_string_literal: true

require 'test_helper'

class InvitationAuthorizerTest < ActiveSupport::TestCase
  def setup
    stub_sample_content_for_new_users
  end

  test "user has account and is authorized" do
    user       = create :user
    group      = create :group
    invitation = create :group_invitation,
                         group:  group,
                         sender: group.owner,
                         email:  user.email

    assert InvitationAuthorizer.call(invitation.token, group, user)
  end

  test "user has account and is not authorized" do
    user       = create :user
    group      = create :group
    invitation = create :group_invitation,
                         group:  group,
                         sender: group.owner,
                         email:  "test@test.test"

    assert_not InvitationAuthorizer.call(invitation.token, group, user)
  end

  test "user is unregistered and is authorized" do
    group      = create :group
    invitation = create :group_invitation,
                         group:  group,
                         sender: group.owner,
                         email:  "test@test.test"

    assert InvitationAuthorizer.call(invitation.token, group, nil)
  end
end
