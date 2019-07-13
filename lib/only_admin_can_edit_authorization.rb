class OnlyAdminCanEditAuthorization < ActiveAdmin::AuthorizationAdapter

  def authorized?(action, subject = nil)
    return false if user.role?
    return true if user.admin?

    return true

    # (user.role == User::ROLES[:partner]) &&
    #   (action == :read)
  end

end

