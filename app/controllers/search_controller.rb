class SearchController < ApplicationController
  before_action :authenticate_user!

  def index
    @items = Item.search_for(params[:text])
  end
end
