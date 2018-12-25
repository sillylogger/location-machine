class ItemsController < ApplicationController

  before_action :authenticate_user!, only: [       :new, :edit, :create, :update, :destroy]
  before_action :set_item,           only: [             :edit,          :update, :destroy]

  # GET /items/1
  def show
    @item = Item.find(params[:id])
  end

  # GET /items/new
  def new
    @item = current_user.location.items.build
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  def create
    location = current_user.location
    @item = location.items.build(item_params)

    if @item.save
      redirect_to @item, notice: 'Item was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /items/1
  def update
    if @item.update(item_params)


      redirect_to @item, notice: 'Item was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /items/1
  def destroy
    @item.destroy
    redirect_to items_url, notice: 'Item was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      location = current_user.location
      @item = location.items.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def item_params
      params.require(:item).permit(:name, :price, :description, :image)
    end
end
