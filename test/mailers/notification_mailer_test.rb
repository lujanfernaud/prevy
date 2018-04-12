require 'test_helper'

class NotificationMailerTest < ActionMailer::TestCase
  def setup
    @user  = users(:woodell)
    @group = groups(:one)
    @owner = @group.owner
  end

  test "#new_membership_request" do
    email = NotificationMailer.new_membership_request(@user, @group)

    assert_email_to(email, @owner)
    assert_email_from(email)
    assert_email_subject(email, "New membership request from " \
                                "#{@user.name} in #{@group.name}")

    assert_match "Hello #{@owner.name},", email.body.encoded
    assert_match "You have a new membership request from " \
                 "#{@user.name} in #{@group.name}.", email.body.encoded

    assert_notifications_link(email)
  end

  test "#declined_membership_request" do
    email = NotificationMailer.declined_membership_request(@user, @group)

    assert_email_to(email, @user)
    assert_email_from(email)
    assert_email_subject(email, "Membership request declined")

    assert_match "Hello #{@user.name},", email.body.encoded
    assert_match "We're sorry to say that your membership request for " \
                 "#{@group.name} was declined.", email.body.encoded

    assert_notifications_link(email)
  end

  test "#new_group_membership" do
    email = NotificationMailer.new_group_membership(@user, @group)

    assert_email_to(email, @user)
    assert_email_from(email)
    assert_email_subject(email, "#{@group.name} membership")

    assert_match "Congratulations #{@user.name}!", email.body.encoded
    assert_match "You have been accepted " \
                 "as a member of #{@group.name}!", email.body.encoded

    assert_notifications_link(email)
  end

  test "#deleted_group_membership" do
    email = NotificationMailer.deleted_group_membership(@user, @group)

    assert_email_to(email, @user)
    assert_email_from(email)
    assert_email_subject(email, "Your #{@group.name} membership was cancelled")

    assert_match "Hello #{@user.name},", email.body.encoded
    assert_match "We're sorry to say that your " \
                 "#{@group.name} membership was cancelled.", email.body.encoded

    assert_notifications_link(email)
  end

  test "#added_to_organizers" do
    email = NotificationMailer.added_to_organizers(@user, @group)

    assert_email_to(email, @user)
    assert_email_from(email)
    assert_email_subject(email, "You are now an organizer in #{@group.name}!")

    assert_match "Congratulations #{@user.name}!", email.body.encoded
    assert_match "You are now an organizer in #{@group.name}!",
                  email.body.encoded

    assert_notifications_link(email)
  end

  test "#deleted_from_organizers" do
    email = NotificationMailer.deleted_from_organizers(@user, @group)

    assert_email_to(email, @user)
    assert_email_from(email)
    assert_email_subject(email,
                         "You are no longer an organizer in #{@group.name}")

    assert_match "Hello #{@user.name},", email.body.encoded
    assert_match "We're sorry to say that you are no longer " \
                 "an organizer in #{@group.name}.", email.body.encoded

    assert_notifications_link(email)
  end

  private

    def assert_email_to(email, user)
      assert_equal [user.email], email.to
    end

    def assert_email_from(email)
      assert_equal ["notifications@letsmeet.com"], email.from
    end

    def assert_email_subject(email, message)
      assert_equal message, email.subject
    end

    def assert_notifications_link(email)
      assert_match "Go to notifications", email.body.encoded
    end
end
