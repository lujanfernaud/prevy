# frozen_string_literal: true

module SessionsHelper
  def logged_in?
    user_signed_in?
  end
end
