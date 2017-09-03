class StaticPagesController < ApplicationController
  def home
    @events = Event.order(created_at: :desc).limit(9)
  end
end
