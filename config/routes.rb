Rails.application.routes.draw do
  resources :transactions
  resources :invoice_items
  resources :invoices
  resources :reviews
  resources :customers
  resources :products
  resources :artisans
  resources :admins
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
