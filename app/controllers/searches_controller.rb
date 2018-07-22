# frozen_string_literal: true

class SearchesController < ApplicationController
  require "will_paginate/array"

  def show
    @groups = Group.unhidden
                   .search(params[:keywords])
                   .paginate(page: params[:page], per_page: 18)
  end
end
