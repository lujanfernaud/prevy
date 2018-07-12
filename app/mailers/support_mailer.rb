# frozen_string_literal: true

class SupportMailer < ApplicationMailer
  default from: "support@prevy.herokuapp.com"

  def welcome(user)
    @user = user

    mail(
      to: user.email,
      subject: "Welcome to Prevy!"
    )
  end
end
