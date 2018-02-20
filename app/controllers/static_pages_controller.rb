class StaticPagesController < ApplicationController
  def home
    @events = Event.upcoming.includes(:address).limit(6)
    @groups = Group.where(hidden: false).limit(6)
  end
end
