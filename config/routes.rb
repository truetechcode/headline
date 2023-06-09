Rails.application.routes.draw do
  root "articles#index"

  resources :users
  resources :articles
  resources :sessions, only: [:new, :create, :destroy]
end
