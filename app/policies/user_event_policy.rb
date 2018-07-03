# frozen_string_literal: true

class UserEventPolicy < ApplicationPolicy
  def index?
    logged_in?
  end
end
