# frozen_string_literal: true

Rails.application.routes.draw do
  root "articles#index"

  resources :users, only: %i[new create], defaults: { format: :html }
  resources :sessions, only: %i[new create destroy], defaults: { format: :html }

  resources :articles, only: %i[create destroy index], defaults: { format: :html } do
    collection do
      get ":country", to: "articles#index", as: "country"
    end
  end

  scope "/api", defaults: { format: :json } do
    resources :users, only: [:create]
    resources :sessions, only: %i[create destroy]
    resources :articles, only: %i[create destroy index] do
      collection do
        get ":country", to: "articles#index", as: "api_country"
      end
    end
  end
end
