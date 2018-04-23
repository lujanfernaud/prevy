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
