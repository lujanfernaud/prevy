class SearchesController < ApplicationController
  require "will_paginate/array"

  def show
    @events_found = Event.search(params[:city], params[:event])
    @events = EventDecorator.collection(@events_found)
                            .paginate(page: params[:page], per_page: 15)
  end
end
