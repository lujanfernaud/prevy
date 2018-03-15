require 'test_helper'

class NotificationMailerTest < ActionMailer::TestCase
  def setup
    @user  = users(:woodell)
    @group = groups(:one)
    @owner = @group.owner
  end

  test "#new_membership_request" do
    email = NotificationMailer.new_membership_request(@user, @group)

    assert_equal [@owner.email], email.to
    assert_equal ["notifications@letsmeet.com"], email.from
    assert_equal "New membership request from " \
                 "#{@user.name} in #{@group.name}", email.subject

    assert_match "Hello #{@owner.name},", email.body.encoded
    assert_match "You have a new membership request from " \
                 "#{@user.name} in #{@group.name}.", email.body.encoded
    assert_match "Go to notifications", email.body.encoded
  end

  test "#declined_membership_request" do
    email = NotificationMailer.declined_membership_request(@user, @group)

    assert_equal [@user.email], email.to
    assert_equal ["notifications@letsmeet.com"], email.from
    assert_equal "Membership request declined", email.subject

    assert_match "Hello #{@user.name},", email.body.encoded
    assert_match "We're sorry to say that your membership request for " \
                 "#{@group.name} was declined.", email.body.encoded
    assert_match "Go to notifications", email.body.encoded
  end

  test "#new_group_membership" do
    email = NotificationMailer.new_group_membership(@user, @group)

    assert_equal [@user.email], email.to
    assert_equal ["notifications@letsmeet.com"], email.from
    assert_equal "#{@group.name} membership", email.subject

    assert_match "Congratulations #{@user.name}!", email.body.encoded
    assert_match "You have been accepted " \
                 "as a member of #{@group.name}!", email.body.encoded
    assert_match "Go to notifications", email.body.encoded
  end

  test "#deleted_group_membership" do
    email = NotificationMailer.deleted_group_membership(@user, @group)

    assert_equal [@user.email], email.to
    assert_equal ["notifications@letsmeet.com"], email.from
    assert_equal "Your #{@group.name} membership was cancelled", email.subject

    assert_match "Hello #{@user.name},", email.body.encoded
    assert_match "We're sorry to say that your " \
                 "#{@group.name} membership was cancelled.", email.body.encoded
    assert_match "Go to notifications", email.body.encoded
  end
end
