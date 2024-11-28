Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources :etfs, only: [:index, :show] do
    resource :favorite, only: [:create, :destroy]
    resources :investments, only: [:new, :create]
  end

  resources :investments, only: [:index, :show, :update, :destroy] do
    resources :contributions, only: [:create, :destroy]
  end

  resources :favorites, only: [:index]
end
