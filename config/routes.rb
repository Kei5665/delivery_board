Rails.application.routes.draw do
  root 'areas#index'

  post "oauth/callback", to: "oauths#callback"
  get "oauth/callback", to: "oauths#callback"
  get "oauth/:provider", to: "oauths#oauth", as: :auth_at_provider
  get 'log_out', to: 'user_sessions#destroy', as: 'log_out'

  namespace :admin do 
    resources :posts
    resources :scrapes, only: %i[create]
    resources :emblems, only: %i[index create new]
    resources :areas, only: %i[index create new]
  end
  resources :quests do
    member do
      get :clear
    end
  end
  resources :posts
  resources :users, only: %i[edit update]
  resources :areas
end
