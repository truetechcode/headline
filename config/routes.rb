Rails.application.routes.draw do
  root "articles#index"

  resources :users
  resources :articles
end
