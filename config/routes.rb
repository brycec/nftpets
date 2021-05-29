Rails.application.routes.draw do
  get 'three/module'
  root 'sessions#welcome'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
  get 'm/:m', to: 'sessions#m'
  get 'm/:m/:w', to: 'sessions#m'

  get 'dead', to: 'users#dead'

  get 'blog', to: 'messages#blog'

  resources :users, :messages, :furbabies, :tokens
end
