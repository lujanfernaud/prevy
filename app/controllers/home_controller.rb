# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    if signed_in?
      @user = find_user

      store_user_events
      store_user_groups
    end

    store_unhidden_groups
  end

  private

    def find_user
      @user = User.find(current_user.id)
    end

    def store_user_events
      user_events   = @user.events_from_groups.includes(:image_placeholder)
      @events_count = user_events.size
      @events       = EventDecorator.collection(user_events.limit(6))
    end

    def store_user_groups
      @user_groups = @user.groups
                          .includes(:image_placeholder)
                          .order(updated_at: :desc)
                          .distinct
    end

    def store_unhidden_groups
      @unhidden_groups = Group.includes(:image_placeholder)
                              .unhidden
                              .random_selection(3)
    end
end
