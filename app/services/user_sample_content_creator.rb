# frozen_string_literal: true

# Creates sample content for every new user.
class UserSampleContentCreator
  def self.call(user)
    new(user).call
  end

  def initialize(user)
    @user  = user
    @group = nil
  end

  def call
    return if user_without_sample_content?

    create_sample_group
    create_sample_event
    create_sample_topics
    create_sample_invitations
    create_sample_membership_request

    update_members_updated_at_date
  end

  private

    attr_reader :user, :group

    def user_without_sample_content?
      user.skip_sample_content? || user.sample_user? || user.admin?
    end

    def create_sample_group
      @group = SampleGroupCreator.call(user)
    end

    def create_sample_event
      SampleEventCreator.call(group)
    end

    def create_sample_topics
      SampleTopicCreator.call(group)
    end

    def create_sample_invitations
      SampleInvitationCreator.call(group, quantity: 3)
    end

    def create_sample_membership_request
      SampleMembershipRequestCreator.call(user)
    end

    def update_members_updated_at_date
      group.members.update_all(updated_at: Time.zone.now)
    end
end
