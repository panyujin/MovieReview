Rails.application.routes.draw do
  devise_for :users
  resources :movies do
    member do
      post :join
      post :quit
    end

    resources :reviews
  end

  namespace :account do
    resources :movies
    resources :reviews
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'movies#index'
end
