Rails.application.routes.draw do
  # Root path
  root 'application#welcome'

  # Admins and their related artisans
  resources :admins, only: %i[show index create update] do
    resources :artisans, only: %i[index new create edit update destroy]
  end

  # Artisans and their related products
  resources :artisans, only: %i[show] do
    resources :products, only: %i[index new create show edit update destroy]
  end

  scope :auth, as: :auth do
    get '/login', to: 'sessions#new', as: :login
    post '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy', as: :logout
  end
end
