# frozen_string_literal: true

require 'test_helper'

class SampleInvitationCreatorTest < ActiveSupport::TestCase
  def setup
    stub_sample_content_for_new_users

    @group = create :group
  end

  test "generates invitations" do
    SampleInvitationCreator.call(@group, quantity: 3)

    invitations = GroupInvitation.where(group: @group)

    assert 3, invitations.size
    assert creation_date_is_not_the_same(invitations)
  end

  private

    def creation_date_is_not_the_same(invitations)
      invitations.map(&:created_at).uniq.size == invitations.size
    end
end
