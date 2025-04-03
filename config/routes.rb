Rails.application.routes.draw do
  # Root and Static Pages
  root 'welcome#index'
  get 'welcome/index'

  # Authentication Routes
  scope :auth, as: :auth do
    get    '/login',  to: 'sessions#new', as: :login
    post   '/login',  to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy', as: :logout
  end

  # Admin Routes and Nested Artisans
  resources :admins, only: %i[new show index create edit update destroy] do
    member do
      get 'dashboard', to: 'admins#dashboard'
    end

    resources :artisans, only: %i[index new create edit update destroy]
  end

  # Artisan Routes and Nested Products/Discounts
  resources :artisans, only: %i[show] do
    member do
      get 'dashboard', to: 'artisans#dashboard'
    end

    resources :products, only: %i[index new create show edit update destroy] do
      resources :discounts, only: %i[new create edit update destroy]
    end
  end

  # ✅ API Namespace: v1
  namespace :api do
    namespace :v1 do
      resources :products, only: [] do
        resources :discounts, only: [:index]
      end
    end
  end

  # Invoices (Standalone for now)
  resources :invoices, only: [:show]
end
