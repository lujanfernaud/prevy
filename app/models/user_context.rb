# frozen_string_literal: true

# Makes possible to access params in Pundit policies.
class UserContext
  attr_reader :user, :params

  def initialize(user, params)
    @user = user
    @params = params
  end
end
