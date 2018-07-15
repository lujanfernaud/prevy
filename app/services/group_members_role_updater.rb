# frozen_string_literal: true

class GroupMembersRoleUpdater
  def self.call(group)
    new(group).call
  end

  def initialize(group)
    @group = group
  end

  def call
    return unless group.saved_change_to_all_members_can_create_events?

    if group.all_members_can_create_events
      add_members_to_organizers
    else
      remove_members_from_organizers
    end
  end

  private

    attr_reader :group

    def add_members_to_organizers
      group.members.each { |member| group.add_to_organizers member }
    end

    def remove_members_from_organizers
      group.members.each { |member| group.remove_from_organizers member }
    end
end
