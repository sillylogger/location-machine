class SearchController < ApplicationController
  before_action :authenticate_user!
  before_action :set_back_path
  before_action :get_origin

  def index
    @items = Item
      .for_nearests(@origin, text: params[:text])
      .limit(20)

    # TODO: follow doc in github, geokit will automate this calculation
    # but it's not working, maybe I miss something in config, will do later
    @items = @items.map do |item|
      item.distance = item.distance_to(@origin)
      item
    end
  end

  private

  def set_back_path
    cookies.permanent[:back_path] = params[:back_path] if params[:back_path]
  end

  def get_origin
    if cookies[:latitude].present?
      @origin = [cookies[:latitude], cookies[:longitude]]
    else
      # TODO: we may store all location history of users, and get the latest one
      @origin = Location.first
    end
  end
end
