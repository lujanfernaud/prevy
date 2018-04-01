class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @user         = User.find(current_user.id)
      user_events   = @user.events_from_groups
      @events_count = user_events.count
      @events       = EventDecorator.collection(user_events.limit(6))
    end

    @groups = Group.where(hidden: false).limit(6)
  end
end
