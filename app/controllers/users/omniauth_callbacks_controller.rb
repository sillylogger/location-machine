class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    @user = User.find_for_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_locale
      set_flash_message(:notice, :success, kind: "facebook".capitalize) if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  # TODO: bring this additional prompt back in the form of
  # a flash notification on the profile#edit
  #
  # def after_sign_in_path_for resource
  #   if resource.prompt_additional_information?
  #     finish_signup_path
  #   else
  #     super resource
  #   end
  # end

  private

  def set_locale
    I18n.locale = current_user_locale.presence || read_lang_header || I18n.default_locale
  rescue I18n::InvalidLocale
    I18n.locale = I18n.default_locale
  end
end
