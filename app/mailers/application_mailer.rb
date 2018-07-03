# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "info@prevy.herokuapp.com"
  layout "mailer"
end
