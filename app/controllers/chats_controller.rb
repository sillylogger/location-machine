class ChatsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.find_by(id: params[:user_id]) or not_found
    @item = Item.find(params[:item_id]) if params[:item_id].present?
  end
end
