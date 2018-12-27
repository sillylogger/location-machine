class ApplicationController < ActionController::Base

  protected

  def authenticate_admin_user!
    authenticate_user!
    redirect_to root_path, alert: 'Sorry, Admins only!' unless current_user.admin?
  end

  def after_sign_in_path_for resource
    default_path = resource.admin? ? admin_dashboard_path : root_path
    stored_location_for(resource) || default_path
  end

end
