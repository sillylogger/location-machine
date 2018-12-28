class PagesController < ApplicationController

  def show
    @page = Page.where(path: params[:path]).first or not_found
  end

end
