# frozen_string_literal: true

class WelcomeEmailJob < ApplicationJob
  def perform(user)
    SupportMailer.welcome(user).deliver_now
  end
end
