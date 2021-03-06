class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_location, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_item, only: [:edit, :update, :destroy]
  before_action :get_user_coordinate, only: [:index]

  protect_from_forgery except: :index

  def index
    @items = Item.latest_in_distance(@user_coordinate).page(1).per(Setting.number_of_newest_items)
    @items = @items.map do |item|
      item.distance = item.distance_to(@user_coordinate.to_latlng)
      item
    end

    respond_to do |format|
      format.js do
        render layout: false
      end
    end
  end

  # GET /locations/1/items/1
  def show
    @location = Location.find params[:location_id]
    @item = @location.items.find params[:id]
  end

  # GET /locations/1/items/new
  def new
    @item = @location.items.build
  end

  # GET /locations/1/items/1/edit
  def edit
  end

  # POST /locations/1/items
  def create
    @item = @location.items.build(item_params)
    if @item.save
      redirect_to @location, notice: 'Item was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /locations/1/items/1
  def update
    if @item.update(item_params)
      redirect_to @location, notice: 'Item was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /locations/1/items/1
  def destroy
    @item.destroy
    redirect_to @location, notice: 'Item was successfully destroyed.'
  end

  private

    def set_location
      @location = current_user.locations.find(params[:location_id])
    end

    def set_item
      @item = @location.items.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def item_params
      params.require(:item).permit(:name, :price, :description, :image)
    end
end
