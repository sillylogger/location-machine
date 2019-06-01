class Users::RegistrationsController < Devise::RegistrationsController

  before_action :authenticate_user!, only: [:finish_signup]

  def finish_signup
    if request.patch? && params[:user] && params[:user][:email]
      if current_user.update(user_params)
        sign_in(current_user, :bypass => true)
        redirect_to root_path, notice: 'Your profile was successfully updated.'
      end
    end
  end

  private

  def account_update_params
    {}
  end

  def update_resource resource, params
    resource.update_without_password(user_params)
  end

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :phone,
      :preferred_locale
    )
  end

end
