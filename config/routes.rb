Rails.application.routes.draw do
  get 'welcome/index'
  # Root path
  root 'welcome#index'

  # Authentication routes
  scope :auth, as: :auth do
    get '/login', to: 'sessions#new', as: :login
    post '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy', as: :logout
  end

  # Admins and their related artisans
  resources :admins, only: %i[new show index create edit update destroy] do
    member do
      get 'dashboard', to: 'admins#dashboard'
    end
    resources :artisans, only: %i[index new create edit update destroy]
  end

# Artisans and their related products
resources :artisans, only: %i[show] do
  member do
    get 'dashboard', to: 'artisans#dashboard'
  end
  resources :products, only: %i[index new create show edit update destroy] do
    resources :discounts, only: %i[new create edit update destroy]
  end
end

  # Invoices (generic, not yet tied to customers)
  resources :invoices, only: [:show]
end
