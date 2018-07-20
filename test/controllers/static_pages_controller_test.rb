# frozen_string_literal: true

require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "#create_group_unconfirmed redirects back to root if not logged in" do
    get create_group_unconfirmed_path

    assert_response :redirect

    assert_current_path root_path
  end

  test "#create_group_unconfirmed shows up when logged in" do
    stub_sample_content_for_new_users

    user = create :user

    sign_in user

    get create_group_unconfirmed_path

    assert_response :success
  end
end
