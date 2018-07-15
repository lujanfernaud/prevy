# frozen_string_literal: true

class GroupUserPolicy
  def self.call(group, user)
    new(group, user).call
  end

  def initialize(group, user)
    @group   = group
    @owner   = group.owner
    @members = group.members
    @user    = user
  end

  def call
    return false unless members.include?(user) || owner == user

    group == user.sample_group || user.confirmed?
  end

  private

    attr_reader :group, :owner, :members, :user
end
