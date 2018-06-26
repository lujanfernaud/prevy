require 'test_helper'

class UsersAnnouncementsNotificationsTest < ActionDispatch::IntegrationTest
  include TopicsIntegrationSupport
  include MailerSupport

  def setup
    @phil    = users(:phil)
    @woodell = users(:woodell)
    @group   = groups(:one)

    stub_new_announcement_topic_mailer
  end

  test "user receives group announcement notification" do
    submit_new_announcement_topic_as(@phil)
    topic = @group.reload.announcement_topics.last
    notification = @woodell.reload.announcement_notifications.last

    log_in_as(@woodell)

    click_on "Notifications"

    assert_group_announcement_notification(notification) do
      click_on "Go to announcement"
    end

    assert_equal group_topic_path(@group, topic), page.current_path
  end

  private

    def submit_new_announcement_topic_as(user)
      prepare_javascript_driver

      log_in_as(user)

      visit group_path(@group)

      submit_new_announcement_topic

      log_out

      Capybara.use_default_driver
    end

    def assert_group_announcement_notification(notification)
      within "#notification-#{notification.id}" do
        assert page.has_content? @group.name
        assert page.has_content? notification.message
        assert page.has_link?    "Go to announcement"
        assert page.has_link?    "Mark as read"

        yield if block_given?
      end
    end
end
