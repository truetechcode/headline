Rails.application.routes.draw do
  root "headlines#index"

  resources :users
end
