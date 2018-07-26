# frozen_string_literal: true

require 'test_helper'

class UserMembershipDecoratorTest < ActiveSupport::TestCase
  def setup
    stub_sample_content_for_new_users
  end

  test "#organizer_tag" do
    user  = create :user
    group = create :group
    group.add_to_organizers user

    result = UserMembershipDecorator.new(group).organizer_tag(user)

    assert result.include? "[Organizer]"
  end

  test "#links for owned group" do
    user  = create :user
    group = create :group, owner: user

    result = UserMembershipDecorator.new(group).links(user)

    assert result.include? "Edit group"
    assert result.include? "Edit roles"
  end

  test "#links for not owned group" do
    user  = create :user
    group = create :group
    group.members << user

    result = UserMembershipDecorator.new(group).links(user)

    assert result.include? "Cancel membership"
  end
end
