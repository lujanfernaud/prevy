# frozen_string_literal: true

# == Schema Information
#
# Table name: group_invitations
#
#  id         :bigint(8)        not null, primary key
#  email      :string
#  name       :string
#  token      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :bigint(8)
#  sender_id  :bigint(8)
#  user_id    :bigint(8)
#
# Indexes
#
#  index_group_invitations_on_group_id   (group_id)
#  index_group_invitations_on_sender_id  (sender_id)
#  index_group_invitations_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (user_id => users.id)
#

require 'test_helper'

class GroupInvitationTest < ActiveSupport::TestCase
  def setup
    stub_sample_content_for_new_users
  end

  test "is not valid without name" do
    invitation = build_stubbed :group_invitation, name: nil

    assert_not invitation.valid?
  end

  test "is not valid with short name" do
    invitation = build_stubbed :group_invitation, name: "A"

    assert_not invitation.valid?
  end

  test "is not valid without email" do
    invitation = build_stubbed :group_invitation, email: nil

    assert_not invitation.valid?
  end

  test "is not valid with bad email" do
    invitation = build_stubbed :group_invitation, email: "phil.example.com"

    assert_not invitation.valid?

    invitation.email = "@example.com"

    assert_not invitation.valid?

    invitation.email = "phil@example"

    assert_not invitation.valid?
  end

  test "is not valid if there's an invitation for the email and group" do
    email = "#{SecureRandom.hex(9)}@test.test"
    group = create :group

    create :group_invitation, group: group, email: email
    invitation = build_stubbed :group_invitation, group: group, email: email

    assert_not invitation.valid?
  end

  test "is not valid if the user is already a member of the group" do
    user  = create :user
    email = user.email
    group = create :group
    group.members << user

    invitation = build_stubbed :group_invitation, group: group, email: email

    assert_not invitation.valid?
  end

  test "generates a token" do
    invitation = create :group_invitation

    assert invitation.token
  end

  test "finds and stores a user if it exists" do
    user       = create :user
    invitation = create :group_invitation, email: user.email

    assert invitation.user
  end
end
