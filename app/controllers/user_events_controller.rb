class UserEventsController < ApplicationController
  require "will_paginate/array"

  def index
    authorize :user_event

    user    = User.find current_user.id
    @events = events_decorators_for user.events_from_groups
  end

  private

    def events_decorators_for(concern)
      EventDecorator.collection(concern)
                    .paginate(page: params[:page], per_page: 15)
    end
end
