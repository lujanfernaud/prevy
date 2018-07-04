# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  admin                  :boolean          default(FALSE)
#  bio                    :string
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  location               :string
#  name                   :string
#  notifications_count    :integer          default(0), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sample_user            :boolean          default(FALSE)
#  settings               :jsonb            not null
#  sign_in_count          :integer          default(0), not null
#  slug                   :string
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_slug                  (slug)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "is valid" do
    user = users(:phil)
    assert user.valid?
  end

  test "is invalid without name" do
    user = users(:phil)
    user.name = ""

    refute user.valid?
  end

  test "is invalid with short name" do
    user = users(:phil)
    user.name = "Ph"

    refute user.valid?
  end

  test "is invalid without email" do
    user = users(:phil)
    user.email = ""

    refute user.valid?
  end

  test "is invalid with bad email" do
    user = users(:phil)
    user.email = "phil.example.com"

    refute user.valid?

    user.email = "@example.com"

    refute user.valid?

    user.email = "phil@example"

    refute user.valid?
  end

  test "is invalid with short password" do
    user = users(:phil)
    user.password = "passw"

    refute user.valid?
  end

  test "#sample_group" do
    someones_sample_group = groups(:sample_group)
    user = fake_user
    user.save!

    assert_equal user.sample_group, user.groups.first

    someones_sample_group.members << user

    refute_equal someones_sample_group, user.sample_group
  end

  test "#membership_request_emails?" do
    phil  = users(:phil)
    penny = users(:penny)
    penny.membership_request_emails = false

    assert phil.membership_request_emails?
    refute penny.membership_request_emails?
  end

  test "#group_membership_emails?" do
    phil  = users(:phil)
    penny = users(:penny)
    penny.group_membership_emails = false

    assert phil.group_membership_emails?
    refute penny.group_membership_emails?
  end

  test "#group_role_emails?" do
    phil  = users(:phil)
    penny = users(:penny)
    penny.group_role_emails = false

    assert phil.group_role_emails?
    refute penny.group_role_emails?
  end

  test "#group_event_emails?" do
    phil  = users(:phil)
    penny = users(:penny)
    penny.group_event_emails = false

    assert phil.group_event_emails?
    refute penny.group_event_emails?
  end

  test "#owned_groups" do
    penny = users(:penny)
    phil  = users(:phil)

    assert_equal 2, penny.owned_groups.size
    assert_equal 1, phil.owned_groups.size
  end

  test "#associated_groups" do
    penny = users(:penny)
    phil  = users(:phil)

    assert_equal [groups(:one), groups(:four)], penny.associated_groups
    assert_equal [groups(:two), groups(:three)], phil.associated_groups
  end

  test "#received_requests" do
    phil = users(:phil)

    assert_equal 2, phil.received_requests.size
  end

  test "#sent_requests" do
    onitsuka = users(:onitsuka)

    assert_equal 1, onitsuka.sent_requests.size
  end

  test "#notifications" do
    stub_sample_content_for_new_users

    user = create :user
    create_list   :notification, 4, user: user

    assert_equal 4, user.notifications_count
  end

  # TODO: Add missing stub_sample_content_for_new_users
  test "titleizes name before saving" do
    user = fake_user(name: "john stevenson")
    user.save!

    assert_equal "John Stevenson", user.name
  end

  test "titleizes location before updating" do
    user = fake_user
    user.save
    user.update_attributes(location: "tenerife")

    assert_equal "Tenerife", user.location
  end

  test "doesn't return an error if there is no location" do
    user = fake_user
    user.save

    assert user.update_attributes(location: nil)
  end

  test "capitalizes bio before updating" do
    bio = "it is impossible to build one's own happiness on the unhappiness of others."
    bio_capitalized = "It is impossible to build one's own happiness on the unhappiness of others."

    user = fake_user
    user.save

    user.update_attributes(bio: bio)

    assert_equal bio_capitalized, user.bio
  end

  test "doesn't return an error if there is no bio" do
    user = fake_user
    user.save

    assert user.update_attributes(bio: nil)
  end

  test "has name as slug" do
    user = fake_user
    name_parameterized = user.name.parameterize

    user.save!

    assert_equal name_parameterized, user.slug
  end
end
