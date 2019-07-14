class OnlyAdminCanEditAuthorization < ActiveAdmin::AuthorizationAdapter

  def authorized?(action, subject = nil)
    return false unless user.role?
    return true if user.admin?

    user.partner? && (:read == action)
  end

end

