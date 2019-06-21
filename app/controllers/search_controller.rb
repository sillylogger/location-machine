class SearchController < ApplicationController
  before_action :authenticate_user!

  def index
    @items = Item.all
  end
end
