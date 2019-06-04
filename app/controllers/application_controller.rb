class ApplicationController < ActionController::Base

  before_action :force_canonical_host
  before_action :set_current_host
  before_action :set_locale

  def set_locale
    cookies.permanent[:locale] = params[:locale] if params[:locale].present?
    I18n.locale = cookies[:locale] || current_user_locale.presence || read_lang_header || I18n.default_locale
  rescue I18n::InvalidLocale
    I18n.locale = I18n.default_locale
  end

  protected

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


  def read_lang_header
    lang_header = request.headers['HTTP_ACCEPT_LANGUAGE']
    lang_header.downcase.scan(/^[a-z]{2}/).first unless lang_header.nil?
  end

  def current_user_locale
    current_user && current_user.locale
  end

  def set_admin_locale
    I18n.locale = :en
  end

end
