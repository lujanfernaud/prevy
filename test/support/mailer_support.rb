module MailerSupport
  def stub_new_announcement_topic_mailer
    mailer = NotificationMailer.new
    NotificationMailer.stubs(:new_announcement_topic).returns(mailer)
    mailer.stubs(:deliver_now)
  end
end
