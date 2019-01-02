class ApplicationController < ActionController::Base

  before_action do
    ActiveStorage::Current.host = request.base_url
  end

  protected

  def authenticate_admin_user!
    authenticate_user!
    redirect_to root_path, alert: 'Sorry, Admins only!' unless current_user.admin?
  end

  def after_sign_in_path_for resource
    default_path = resource.admin? ? admin_dashboard_path : root_path
    stored_location_for(resource) || default_path
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

end
