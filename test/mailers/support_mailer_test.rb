# frozen_string_literal: true

require 'test_helper'

class SupportMailerTest < ActionMailer::TestCase
  def setup
    @user = build_stubbed :user
  end

  test "#welcome" do
    email = SupportMailer.welcome(@user)

    assert_email_to(email, @user)
    assert_email_from(email)
    assert_email_subject(email, "Welcome to Prevy!")

    assert_match "Welcome #{@user.name}!", email.body.encoded

    assert_match "Enjoy!",                 email.body.encoded

    assert_match "Luj=C3=A1n",             email.body.encoded
    assert_match "hello@lujanfernaud.com", email.body.encoded
    assert_match "prevy.herokuapp.com",    email.body.encoded
  end

  private

    def assert_email_to(email, user)
      assert_equal [user.email], email.to
    end

    def assert_email_from(email)
      assert_equal ["support@prevy.herokuapp.com"], email.from
    end

    def assert_email_subject(email, message)
      assert_equal message, email.subject
    end
end
