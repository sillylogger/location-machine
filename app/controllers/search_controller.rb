class SearchController < ApplicationController
  before_action :set_back_path
  before_action :get_user_location

  protect_from_forgery except: :index

  def index
    @items = SearchDocument
      .for_nearests(@user_location, text: params[:text])
      .page(params[:page] || 1).per(15)

    @total_pages = @items.total_pages

    # TODO: follow doc in github, geokit will automate this calculation
    # but it's not working, maybe I miss something in config, will do later
    @items = @items.map do |item|
      item.distance = item.distance_to(@user_location)
      item
    end

    respond_to do |format|
      format.html
      format.js do
        render layout: false
      end
    end
  end

  private

  def set_back_path
    cookies.permanent[:back_path] = params[:back_path] if params[:back_path]
  end
end
