# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/support_mailer

class SupportMailerPreview < ActionMailer::Preview
  def welcome
    SupportMailer.welcome(User.last)
  end
end
