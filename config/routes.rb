Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/p/:path' => 'pages#show', :as => :page

  resources :locations do
    resources :items
  end

  root to: "locations#index"

  devise_for :users, controllers: {
    registrations:      'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  # match '/users/finish_signup' => 'users/registrations#finish_signup', via: [:get, :patch], :as => :finish_signup

  ActiveAdmin.routes(self)

end
