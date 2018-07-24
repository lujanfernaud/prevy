# frozen_string_literal: true

module MailerSupport
  def stub_new_announcement_topic_mailer
    mailer = NotificationMailer.new
    NotificationMailer.stubs(:new_announcement_topic).returns(mailer)
    mailer.stubs(:deliver_later)
  end

  def select_email_delivery_for(email)
    ActionMailer::Base.deliveries.select do |delivery|
      delivery.to == [email]
    end.first
  end
end
