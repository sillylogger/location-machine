class LocationsController < ApplicationController

  before_action :authenticate_user!,  except: [:index, :show]
  before_action :set_location,        only:   [:edit, :update, :destroy]

  # GET /
  def index
    @locations =
      if params[:search_in_bounds]
        bounds = params[:search_in_bounds]
        Location.in_bounds(bounds[:sw_lat], bounds[:sw_lng], bounds[:ne_lat], bounds[:ne_lng])
      else
        Location.for_display
      end.newest.limit(Setting.site_limit_location)

    respond_to do |format|
      format.html
      format.json { render json: @locations.to_json}
    end
  end

  # GET /locations/1
  def show
    @location = Location.find params[:id]
  end

  # GET /locations/new
  def new
    @location = Location.new
    @location.items.build
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations
  def create
    @location = current_user.locations.new(location_params)
    if @location.save
      redirect_to @location, notice: 'Location was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /locations/1
  def update
    if @location.update(location_params)
      redirect_to @location, notice: 'Location was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /locations/1
  def destroy
    @location.destroy
    redirect_to root_path, notice: 'Location was successfully destroyed.'
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = current_user.locations.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:location).permit(
        :latitude,
        :longitude,
        :name,
        :address,
        :description,
        items_attributes: [
          :id,
          :image,
          :name,
          :price,
          :description
        ]
      )
    end

end
