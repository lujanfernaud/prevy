class StaticPagesController < ApplicationController
  def home
    @events = Event.upcoming.limit(9)
  end
end
