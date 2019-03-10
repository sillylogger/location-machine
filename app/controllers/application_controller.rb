class ApplicationController < ActionController::Base

  before_action :force_canonical_host
  before_action :set_current_host
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

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


  def force_canonical_host
    desired_host = Setting.get('site.host')
    if desired_host && (request.host != desired_host)
      host_with_port = request.host_with_port.sub(request.host, desired_host)
      redirect_to ["//", host_with_port, request.fullpath].join('')
    end
  end

  def set_current_host
    ActiveStorage::Current.host = request.base_url
  end

end
