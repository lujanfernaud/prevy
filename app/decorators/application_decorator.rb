# frozen_string_literal: true

class ApplicationDecorator < SimpleDelegator
  delegate :class, :is_a?, to: :__getobj__

  protected

    def h
      ActionController::Base.helpers
    end

    def url
      Rails.application.routes.url_helpers
    end
end
