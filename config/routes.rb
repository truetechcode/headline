Rails.application.routes.draw do
  root "articles#index"

  resources :users
  resources :articles do
    collection  do
      get ':country', to: 'articles#index', as: 'country'
    end
  end
  resources :sessions, only: [:new, :create, :destroy]
end
