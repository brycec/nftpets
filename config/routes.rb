Rails.application.routes.draw do
  root 'sessions#welcome'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'

  get 'dead', to: 'users#dead'

  resources :users, :messages, :furbabies, :tokens
end
