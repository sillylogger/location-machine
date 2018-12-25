Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: {
    registrations:      'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  #
  # match '/users/finish_signup' => 'users/registrations#finish_signup', via: [:get, :patch], :as => :finish_signup
  #

  resources :items
  resources :locations

  root to: "application#index"

end
