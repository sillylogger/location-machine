Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "locations#index"

  get '/p/:path'          => 'pages#show', :as => :page

  resources :locations do
    resources :items
  end

  get '/search(.:format)' => 'search#index', :as => :search

  devise_for :users, controllers: {
    registrations:      'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :users do
    resources :chats, only: [:index]
    resources :coordinators, only: [:create]
  end

  # match '/users/finish_signup' => 'users/registrations#finish_signup', via: [:get, :patch], :as => :finish_signup

  ActiveAdmin.routes(self) rescue ActiveAdmin::DatabaseHitDuringLoad

end
