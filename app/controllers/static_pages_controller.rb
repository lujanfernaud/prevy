class StaticPagesController < ApplicationController
  def home
    @events = Event.upcoming.includes(:address).limit(9)
  end
end
