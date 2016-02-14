class PartiesController < ApplicationController

  before_action :set_party, only: [:edit, :update, :destroy]

  # GET /parties/new
  def new
    @party = Party.new
  end

  # GET /parties/1/edit
  def edit
  end

  # POST /parties
  def create
    @party = current_user.parties.new(party_params)

    if @party.save
      redirect_to root_path, notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /parties/1
  def update
    if @party.update(party_params)
      redirect_to root_path, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /parties/1
  def destroy
    @party.destroy
    redirect_to parties_url, notice: 'Event was successfully destroyed.'
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_party
      @party = current_user.parties.find params[:id]
    end

    # Only allow a trusted parameter "white list" through.
    def party_params
      params.require(:party).permit(:name, :description, :opens, :closes, :latitude, :longitude)
    end

end
