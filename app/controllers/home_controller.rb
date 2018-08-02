# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    if user
      store_user_events
      store_user_groups
    end

    store_unhidden_groups
  end

  private

    def user
      return unless current_user

      @user = User.find(current_user.id)
    end

    def store_user_events
      user_events   = @user.events_from_groups
      @events_count = user_events.size
      @events       = EventDecorator.collection(user_events.limit(6))
    end

    def store_user_groups
      @user_groups = @user.groups.order(updated_at: :desc)
    end

    def store_unhidden_groups
      @unhidden_groups = Group.unhidden.random_selection(limit)
    end

    def limit
      current_user ? 3 : 6
    end

    def resource
      @resource ||= User.new
    end

    def resource_name
      :user
    end

    helper_method :resource, :resource_name
end
