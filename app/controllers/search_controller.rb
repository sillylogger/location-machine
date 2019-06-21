class SearchController < ApplicationController
  before_action :authenticate_user!

  def index
    # TODO: we can add pagination here and maybe add 'see more' in search page
    @items = Item.search_for(params[:text]).limit(10)
  end
end
