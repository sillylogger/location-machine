class UsersController < ApplicationController

  before_action :authenticate_user!

  def finish_signup
    if request.patch? && params[:user] && params[:user][:email]
      if current_user.update(user_params)
        sign_in(current_user, :bypass => true)
        redirect_to root_path, notice: 'Your profile was successfully updated.'
      end
    end
  end

  private

  def user_params
    params.require(:user).permit([
      :name,
      :email,
      :phone,
      :password
    ])
  end

end
