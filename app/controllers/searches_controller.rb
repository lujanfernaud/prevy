class SearchesController < ApplicationController
  require "will_paginate/array"

  def show
    @groups = Group.search(params[:location], params[:group])
                   .paginate(page: params[:page], per_page: 15)
  end
end
