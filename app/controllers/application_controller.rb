class ApplicationController < ActionController::Base

  def index
    @locations = Location.all
  end

end
