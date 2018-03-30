class StaticPagesController < ApplicationController
  def home
    upcoming_events = Event.upcoming.includes(:address).limit(6)
    @events = EventDecorator.collection(upcoming_events)
    @groups = Group.where(hidden: false).limit(6)
  end
end
