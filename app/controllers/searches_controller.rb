class SearchesController < ApplicationController
  def show
    @events = Event.search(params[:city], params[:event])
                   .paginate(page: params[:page], per_page: 15)
  end
end
