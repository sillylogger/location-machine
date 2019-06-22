class SearchController < ApplicationController
  before_action :authenticate_user!

  def index
    cookies.permanent[:back_path] = params[:back_path] if params[:back_path]
    if cookies[:latitude].present?
      origin = [cookies[:latitude], cookies[:longitude]]
    else
      # TODO: we may store all location history of users, and get the latest one
      origin = Location.first
    end
    return unless params[:text].present?
    @items = Item
      .joins(:location)
      .within(50, origin: origin)
      .by_distance(origin: origin)
      .search_for(params[:text])
      .limit(20)
    @items = @items.map do |item|
      item.distance = item.distance_to(origin)
      item
    end
  end
end
