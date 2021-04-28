Rails.application.routes.draw do
  resources :furbabies
  resources :tokens
  resources :users
  root 'sessions#welcome'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
end
