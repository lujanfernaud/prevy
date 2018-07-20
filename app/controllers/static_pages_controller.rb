# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def create_group_unconfirmed
  end

  def hidden_group
  end

  private

    # Store the referrer instead of the current path, so we are redirected
    # back to the group page.
    #
    # See ApplicationController for reference.
    def store_user_location
      store_location_for(:user, request.referrer)
    end
end
