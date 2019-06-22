class SearchController < ApplicationController
  before_action :authenticate_user!

  def index
    cookies.permanent[:back_path] = params[:back_path] if params[:back_path]
    location = Location.first
    @items = Item
      .joins(:location)
      .within(50, origin: location)
      .by_distance(origin: location)
      .search_for(params[:text])
      .limit(20)
    @items = @items.map do |item|
      item.distance = item.distance_to(location)
      item
    end
  end
end
