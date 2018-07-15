# frozen_string_literal: true

# == Schema Information
#
# Table name: groups
#
#  id                            :bigint(8)        not null, primary key
#  all_members_can_create_events :boolean          default(FALSE)
#  description                   :string
#  events_count                  :integer          default(0), not null
#  hidden                        :boolean          default(FALSE)
#  image                         :string
#  location                      :string
#  members_count                 :integer          default(0), not null
#  name                          :string
#  sample_group                  :boolean          default(FALSE)
#  slug                          :string
#  topics_count                  :integer          default(0), not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  user_id                       :bigint(8)
#
# Indexes
#
#  index_groups_on_location  (location)
#  index_groups_on_slug      (slug)
#  index_groups_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  def setup
    stub_sample_content_for_new_users

    @group   = groups(:one)
    @woodell = users(:woodell)
  end

  test "is valid" do
    group = fake_group

    assert group.valid?
  end

  test "is invalid without location" do
    group = fake_group(location: "")

    refute group.valid?
  end

  test "is invalid without name" do
    group = fake_group(name: "")

    refute group.valid?
  end

  test "is invalid with short name" do
    group = fake_group(name: "Gr")

    refute group.valid?
  end

  test "is invalid without description" do
    group = fake_group(description: "")

    refute group.valid?
  end

  test "is invalid with short description" do
    group = fake_group(description: "Our group")

    refute group.valid?
  end

  test "is invalid without an image" do
    group = fake_group(image: "")

    refute group.valid?
  end

  test ".unhidden" do
    groups = Group.unhidden

    assert groups.none? { |group| group.hidden? }
  end

  test ".unhidden_without" do
    group = groups(:one)

    groups_selection = Group.unhidden_without(group)

    refute groups_selection.include?(group)
  end

  test "#owner" do
    group = fake_group(owner: users(:penny))

    assert_equal group.owner.name, "Penny"
  end

  test "#members" do
    group   = groups(:one)
    penny   = users(:penny)
    woodell = users(:woodell)

    assert_equal [penny, woodell], group.members
  end

  test "#events" do
    event = create :event
    group = event.group

    assert_not group.events_count.zero?
  end

  test "destroys roles" do
    group = groups(:one)
    user  = users(:woodell)

    user.add_role :member, group

    group.destroy

    assert_empty group.roles
  end

  test "titleizes name before saving" do
    group = fake_group(name: "john's group")

    group.save!

    assert_equal "John's Group", group.name
  end

  test "titleizes location before saving" do
    group = fake_group(location: "the universe")

    group.save!

    assert_equal "The Universe", group.location
  end

  test "capitalizes description before saving" do
    description = "no one saves us but ourselves. No one can and no one may. We ourselves must walk the path."
    description_capitalized = "No one saves us but ourselves. No one can and no one may. We ourselves must walk the path."

    group = fake_group(description: description)

    group.save!

    assert_equal description_capitalized, group.description
  end

  test "creates owner UserGroupPoints" do
    group = fake_group
    user  = group.owner

    UserGroupPoints.expects(:create!).with(user: user, group: group)

    group.save!
  end

  test "destroys owner UserGroupPoints" do
    group = fake_group
    user  = group.owner

    group_points = UserGroupPoints.new
    UserGroupPoints.expects(:find_by)
                   .with(user: user, group: group)
                   .returns(group_points)
    group_points.expects(:destroy)

    group.save!
    group.destroy
  end

  test "updates members role" do
    group = create :group

    GroupMembersRoleUpdater.expects(:call).with(group)

    group.update_attributes(all_members_can_create_events: true)
  end

  test "adds owner as organizer and moderator after creation" do
    group = fake_group
    owner = group.owner

    assert_empty group.organizers

    group.save!

    assert_equal owner, group.organizers.last
    assert_equal owner, group.moderators.last
  end

  test "#add_to_organizers" do
    GroupRoleAdder.expects(:call).with(@group, @woodell, :organizer)

    @group.add_to_organizers @woodell
  end

  test "#remove_from_organizers" do
    GroupRoleRemover.expects(:call).with(@group, @woodell, :organizer)

    @group.remove_from_organizers @woodell
  end

  test "#add_to_moderators" do
    GroupRoleAdder.expects(:call).with(@group, @woodell, :moderator)

    @group.add_to_moderators @woodell
  end

  test "#remove_from_moderators" do
    GroupRoleRemover.expects(:call).with(@group, @woodell, :moderator)

    @group.remove_from_moderators @woodell
  end

  test "#topics_prioritized without normal topics limit" do
    group = groups(:two)

    PrioritizedTopicsQuery.expects(:call).with(group, nil)

    group.topics_prioritized
  end

  test "#topics_prioritized with normal topics limit limit" do
    group = groups(:two)

    PrioritizedTopicsQuery.expects(:call).with(group, 5)

    group.topics_prioritized(normal_topics_limit: 5)
  end

  test "#recent_members" do
    group = create :group
    member_one = SampleUser.all.last
    member_one.created_at = 1.month.ago
    member_two = SampleUser.all.first
    member_two.created_at = 1.day.ago

    group.members << [member_one, member_two]

    expected = [member_one.name, member_two.name]

    assert_equal expected, group.recent_members.pluck(:name)
  end

  test "#top_members" do
    group = groups(:one)

    TopMembersQuery.expects(:call).with(group, 12)

    group.top_members(limit: 12)
  end

  test "#user_is_authorized?" do
    GroupUserPolicy.expects(:call).with(@group, @woodell)

    @group.user_is_authorized? @woodell
  end

  test "has name as slug" do
    group = fake_group
    name_parameterized = group.name.parameterize

    group.save!

    assert_equal name_parameterized, group.slug
  end
end
