class SearchController < ApplicationController
  before_action :set_back_path
  before_action :get_origin

  protect_from_forgery except: :index

  def index
    @items = Item
      .for_nearests(@origin, text: params[:text])
      .page(page).per(item_per_page)

    @locations = Location
      .for_nearests(@origin, text: params[:text])
      .page(page).per(item_per_page)

    @total_pages = @items.total_pages

    # TODO: follow doc in github, geokit will automate this calculation
    # but it's not working, maybe I miss something in config, will do later
    @items = set_distance(@items)
    @locations = set_distance(@locations)

    respond_to do |format|
      format.html
      format.js do
        render layout: false
      end
    end
  end

  private

  def page
    params[:page] || 1
  end

  def item_per_page
    15
  end

  def set_distance(results)
    results.map do |result|
      result.distance = result.distance_to(@origin)
      result
    end
  end

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
