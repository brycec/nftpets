Rails.application.routes.draw do
  resources :users
  resources :messages
  resources :furbabies
  resources :tokens
  root 'sessions#welcome'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
end
