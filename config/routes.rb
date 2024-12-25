Rails.application.routes.draw do
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  # Root path
  root 'application#welcome'

  # Admins and their related artisans
  resources :admins, only: %i[show index create update] do
    resources :artisans, only: %i[index new create edit update destroy]
  end

  # Authentication routes
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
