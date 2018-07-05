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

class SampleUserTest < ActiveSupport::TestCase
  def setup
    stub_geocoder
  end

  test "creates a sample user" do
    user = SampleUser.create!(sample_user_params)

    assert user.confirmed?
    assert user.sample_user?
  end

  test "does not create a group after a sample user is created" do
    user = SampleUser.create!(sample_user_params)

    assert_nil user.sample_group
    assert_empty user.owned_groups
  end

  test ".all" do
    SampleUser.all.each do |user|
      assert user.sample_user?
    end
  end

  test ".collection_for_sample_group" do
    assert_not_equal SampleUser.all, SampleUser.collection_for_sample_group
  end

  test ".select_random_users" do
    prevy_bot = users(:prevy_bot)
    sample_users_count = SampleUser.all.size

    (sample_users_count * 2).times do
      assert_not_equal prevy_bot, SampleUser.select_random_users(1).first
    end
  end

  private

    def sample_user_params
      {
        name:                  Faker::Name.name,
        email:                 Faker::Internet.email,
        password:              "password",
        password_confirmation: "password",
        location:              Faker::Address.city,
        bio:                   Faker::BackToTheFuture.quote
      }
    end
end
